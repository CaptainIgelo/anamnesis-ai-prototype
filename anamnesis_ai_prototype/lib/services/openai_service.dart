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
    final questionnaireItems = await _questionnaireService.loadQuestionnaireItems();

    final promptQuestionnaire = questionnaireItems
        .map((item) => {
              'linkId': item.linkId,
              'text': item.text,
              'answerOptions': item.answerOptions,
            })
        .toList();

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
              'questionnaire': promptQuestionnaire,
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
        .whereType<Map<String, dynamic>>()
        .map(AnalysisResult.fromJson)
        .where((item) => item.linkId.isNotEmpty && item.answer.isNotEmpty)
        .toList();
  }

  static const String _systemPrompt = '''
You are a trained hospital nurse performing structured anamnesis extraction from a German nursing admission interview.

Your task is to extract as many relevant questionnaire answers as possible from the transcript.

Rules:
- Use the provided questionnaire data as the only source of valid linkIds.
- Use linkIds exactly as provided in the questionnaire.
- Do not invent, rename, shorten, or reformat linkIds.
- Read the full transcript carefully and extract all answers that can be inferred with reasonable confidence.
- Do not limit yourself to only the most obvious 2 or 3 fields.
- Return every questionnaire item that is clearly or strongly implied by the transcript.
- If a questionnaire item has predefined answer options, choose the best matching option from the provided answerOptions.
- For answer options, use the option text exactly as provided.
- If a questionnaire item expects free text, return a concise German free-text answer.
- Prefer specific, short, structured answers over long explanations.
- Omit only fields that truly cannot be answered from the transcript.
- Do not invent facts.
- Do not include explanations.
- Do not include null values.
- Do not include empty strings.
- Return valid JSON only.
- Do not return markdown.

Important extraction behavior:
- Also extract demographic, social, mobility, support, contact, religion, risk, medication, disease, communication, consent, nutrition, addiction, orientation, and valuables-related information if present.
- If the transcript contains multiple relevant details, return all matching questionnaire answers.
- If the transcript contains explicit negations such as "no", "none", or "not known", use them when they answer a questionnaire item.
- Keep the answer language in German.

Required JSON structure:
{
  "results": [
    {
      "linkId": "NITSVAn08",
      "answer": "Notfall"
    }
  ]
}
''';

  Future<List<AnalysisResult>> _mockAnalyzeTranscript() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      AnalysisResult(linkId: 'NITSVAn08', answer: 'Notfall'),
      AnalysisResult(linkId: 'NITSVAn11', answer: 'liegend'),
      AnalysisResult(linkId: 'NITSVAn103', answer: 'Verwitwet'),
    ];
  }
}