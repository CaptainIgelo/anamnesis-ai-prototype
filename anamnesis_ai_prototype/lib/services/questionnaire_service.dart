import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/questionnaire_item.dart';

class QuestionnaireService {
  Future<List<QuestionnaireItem>> loadSampleQuestionnaire() async {
    final jsonString = await rootBundle.loadString(
      'assets/questionnaire/questionnaire_sample.json',
    );

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final items = jsonMap['item'] as List<dynamic>? ?? [];

    return items
        .map((item) => QuestionnaireItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<String> loadSampleTranscript() async {
    return rootBundle.loadString(
      'assets/transcripts/interview_sample.txt',
    );
  }
}