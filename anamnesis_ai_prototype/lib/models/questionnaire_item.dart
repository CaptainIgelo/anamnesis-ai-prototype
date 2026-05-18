class QuestionnaireItem {
  final String linkId;
  final String text;
  final List<String> answerOptions;

  const QuestionnaireItem({
    required this.linkId,
    required this.text,
    required this.answerOptions,
  });

  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    final options = (json['answer'] as List<dynamic>? ?? [])
        .map((option) => option['valueString']?.toString() ?? '')
        .where((value) => value.isNotEmpty)
        .toList();

    return QuestionnaireItem(
      linkId: json['linkId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      answerOptions: options,
    );
  }
}
