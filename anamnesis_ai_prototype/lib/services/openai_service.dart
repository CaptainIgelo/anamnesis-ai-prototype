import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/analysis_result.dart';
import 'questionnaire_service.dart';

class OpenAiService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  final QuestionnaireService _questionnaireService = QuestionnaireService();

  Future<List<AnalysisResult>> analyzeTranscript(String transcript) async {
    if (AppConfig.useMockOpenAi) {
      return _mockAnalyzeTranscript();
    }

    return _callOpenAi(transcript);
  }

  Future<List<AnalysisResult>> _callOpenAi(String transcript) async {
    final questionnaireJson = await _questionnaireService
        .loadQuestionnaireJson();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4.1',
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          {
            'role': 'user',
            'content': jsonEncode({
              'instruction':
                  'Analyze the nursing interview transcript using the provided questionnaire. Return JSON only.',
              'questionnaire': questionnaireJson,
              'transcript': transcript,
              'output_format': {
                'results': [
                  {'linkId': 'string', 'answer': 'string'},
                ],
              },
            }),
          },
        ],
        'max_tokens': 4000,
        'temperature': 0.1,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'OpenAI API error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['choices'][0]['message']['content'] as String;

    final parsed = jsonDecode(content) as Map<String, dynamic>;
    final resultsJson = parsed['results'] as List? ?? [];

    return resultsJson
        .map((item) => AnalysisResult.fromJson(item as Map<String, dynamic>))
        .where((item) => item.linkId.isNotEmpty && item.answer.isNotEmpty)
        .toList();
  }

  static const String _systemPrompt = '''
You are a trained hospital nurse performing structured anamnesis extraction.

Task:
- Analyze a pasted nursing interview transcript.
- Use the provided questionnaire JSON as the source of valid questions.
- Return only answers that can be derived from the transcript with reasonable confidence.
- If a questionnaire item contains predefined answer options, choose the best matching option.
- If an answer is free text, return concise free text.
- Omit fields that cannot be answered from the transcript.
- Return valid JSON only.
- Do not return markdown.
- Do not return explanations.

Required JSON structure:
{
  "results": [
    {
      "linkId": "NIT_SVAn_08",
      "answer": "Notfall"
    }
  ]
}
''';

  Future<List<AnalysisResult>> _mockAnalyzeTranscript() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      AnalysisResult(linkId: 'NIT_SVAn_08', answer: 'Notfall'),
      AnalysisResult(linkId: 'NIT_SVAn_11', answer: 'liegend'),
      AnalysisResult(linkId: 'NIT_SVAn_103', answer: 'Verwitwet'),
    ];
  }
}
