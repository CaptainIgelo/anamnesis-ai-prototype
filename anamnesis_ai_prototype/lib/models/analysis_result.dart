class AnalysisResult {
  final String linkId;
  final String answer;

  const AnalysisResult({required this.linkId, required this.answer});

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      linkId: (json['linkId'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
    );
  }
}
