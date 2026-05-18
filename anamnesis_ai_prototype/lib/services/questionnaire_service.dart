import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/questionnaire_item.dart';

class QuestionnaireService {
  Future<Map<String, dynamic>> loadQuestionnaireJson() async {
    final jsonString = await rootBundle.loadString(
      'assets/questionnaire/questionnaire_sample.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<List<QuestionnaireItem>> loadQuestionnaireItems() async {
    final jsonMap = await loadQuestionnaireJson();
    final items = jsonMap['item'] as List<dynamic>? ?? [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(QuestionnaireItem.fromJson)
        .where((item) => item.linkId.isNotEmpty && item.text.isNotEmpty)
        .toList();
  }

  Future<String> loadSampleTranscript() async {
    return rootBundle.loadString('assets/transcripts/interview_sample.txt');
  }
}