class AnalysisResult {
    final String linkId;
    final String question; 
    final String answer; 
    final String confidence; 


    const AnalysisResult({
        required this.linkId,
        required this.question, 
        required this.answer,
        required this.confidence, 
    });
}