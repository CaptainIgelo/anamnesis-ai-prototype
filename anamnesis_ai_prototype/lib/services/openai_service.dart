import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/analysis_result.dart';

class OpenAiService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<List<AnalysisResult>> analyzeTranscript(String transcript) async {
    if (AppConfig.useMockOpenAi) {
      return _mockAnalyzeTranscript(transcript);
    }

    return _callOpenAi(transcript);
  }

  Future<List<AnalysisResult>> _callOpenAi(String transcript) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content': _systemPrompt,
          },
          {
            'role': 'user',
            'content': 'Transcript: $transcript',
          },
        ],
        'max_tokens': 1200,
        'temperature': 0.1,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;

    print('OPENAI RAW RESPONSE START');
    print(content);
    print('OPENAI RAW RESPONSE END');

    return _parseOpenAiResponse(content);
  }

  static const String _systemPrompt = '''
Du analysierst Pflege-Anamnese-Transkripte und extrahierst strukturierte Antworten.

WICHTIG:
- Antworte ausschließlich im folgenden Format.
- Keine Einleitung.
- Keine Erklärungen.
- Kein Markdown.
- Kein Codeblock.
- Nur Treffer aus den erlaubten Feldern.
- Eine Zeile pro Treffer.
- Wenn ein Feld nicht sicher aus dem Transkript hervorgeht, lasse es weg.
- Verwende nur diese Werte, wenn eindeutig erkennbar.

Format je Zeile:
linkId:ID|answer:TEXT|confidence:high

Erlaubte Felder:
NITSVAn08 = Art der Aufnahme auf die Station
- mögliche Antworten: Geplante Aufnahme, Verlegung, Notfall, Wiederaufnahme

NITSVAn11 = Pat. wurde aufgenommen
- mögliche Antworten: gehend, sitzend, liegend

NITSVAn103 = Familienstand
- mögliche Antworten: Verheiratet, Geschieden, Getrennt lebend, Verwitwet, Alleinstehend, Eheähnliche Gemeinschaft

Beispiel:
linkId:NITSVAn08|answer:Notfall|confidence:high
linkId:NITSVAn11|answer:liegend|confidence:high
linkId:NITSVAn103|answer:Verwitwet|confidence:medium

Wenn kein einziger Treffer gefunden wird, antworte exakt so:
linkId:N/A|answer:No match|confidence:low
''';

  List<AnalysisResult> _parseOpenAiResponse(String response) {
    final results = <AnalysisResult>[];

    for (final rawLine in response.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || !line.contains('linkId:')) continue;

      final parts = line.split('|');
      String linkId = 'N/A';
      String answer = '';
      String confidence = 'low';

      for (final part in parts) {
        final pieces = part.split(':');
        if (pieces.length < 2) continue;

        final key = pieces.first.trim();
        final value = pieces.sublist(1).join(':').trim();

        if (key == 'linkId') linkId = value;
        if (key == 'answer') answer = value;
        if (key == 'confidence') confidence = value.toLowerCase();
      }

      results.add(
        AnalysisResult(
          linkId: linkId,
          question: '',
          answer: answer,
          confidence: confidence,
        ),
      );
    }

    if (results.isEmpty) {
      return [
        AnalysisResult(
          linkId: 'N/A',
          question: 'No structured response',
          answer: 'OpenAI returned no matches',
          confidence: 'low',
        ),
      ];
    }

    return results;
  }

  Future<List<AnalysisResult>> _mockAnalyzeTranscript(String transcript) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final normalized = transcript.toLowerCase();
    final results = <AnalysisResult>[];

    if (normalized.contains('notfall')) {
      results.add(
        const AnalysisResult(
          linkId: 'NITSVAn08',
          question: 'Art der Aufnahme auf die Station',
          answer: 'Notfall',
          confidence: 'high',
        ),
      );
    }

    if (normalized.contains('liegend')) {
      results.add(
        const AnalysisResult(
          linkId: 'NITSVAn11',
          question: 'Pat. wurde aufgenommen',
          answer: 'liegend',
          confidence: 'high',
        ),
      );
    }

    if (normalized.contains('verwitwet') ||
        normalized.contains('frau ist vor fünf jahren gestorben') ||
        normalized.contains('frau ist vor funf jahren gestorben')) {
      results.add(
        const AnalysisResult(
          linkId: 'NITSVAn103',
          question: 'Familienstand',
          answer: 'Verwitwet',
          confidence: 'medium',
        ),
      );
    }

    if (results.isEmpty) {
      results.add(
        const AnalysisResult(
          linkId: 'N/A',
          question: 'No structured match found',
          answer: 'No result from mock analysis',
          confidence: 'low',
        ),
      );
    }

    return results;
  }
}