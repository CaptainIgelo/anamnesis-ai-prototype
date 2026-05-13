import '../models/analysis_result.dart'; 

class AnalysisService {
    Future<List<AnalysisResult>> analyzeTranscript(String transcript) async {
        await Future.delayed(const Duration(milliseconds: 500));

        final normalized = transcript.toLowerCase();
        final results = <AnalysisResult>[]; 


        if (normalized.contains('notfall')) {
            results.add(
                const AnalysisResult(
                    linkId: 'NITSV08',
                    question: 'Art der Aufnahme auf die Station', 
                    answer: 'Notfall',
                    confidence: 'high',
                ),
            );
        }



        if (normalized.contains('liegend')) {
            results.add(
                const AnalysisResult(
                    linkId: 'NITSVn11', 
                    question: 'Pat. wurde aufgenommen',
                    answer: 'liegend',
                    confidence: 'high',
                ),
            );
        }


        if (normalized.contains('werwitwet') || normalized.contains('frau ist vor fünf jahren gestorben') || normalized.contains('frau ist vor fünf Jahren gestorben')) {
            results.add(
                const AnalysisResult(
                    linkId: 'NITSVAn103',
                    question: 'Familienstand',
                    answer: 'Verwitwet',
                    confidence: 'medium', 
                ),
            );
        }

        return results;
    }
}