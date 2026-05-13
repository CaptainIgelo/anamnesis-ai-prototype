import '../config/app_config.dart';
import '../models/analysis_result.dart';

class OpenAiService {
  Future<List<AnalysisResult>> analyzeTranscript(String transcript) async {
    if (AppConfig.useMockOpenAi) {
      return _mockAnalyzeTranscript(transcript);
    }

    throw UnimplementedError(
      'Real OpenAI integration will be added later on the local machine.',
    );
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