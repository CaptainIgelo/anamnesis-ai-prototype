import 'dart:convert';
import 'package:flutter/services.dart';

class QuestionnaireService {
  Future<Map<String, dynamic>> loadQuestionnaireJson() async {
    final jsonString = await rootBundle.loadString(
      'assets/questionnaire/questionnaire_sample.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<String> loadSampleTranscript() async {
    return rootBundle.loadString('assets/transcripts/interview_sample.txt');
  }
}
