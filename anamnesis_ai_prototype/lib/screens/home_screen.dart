import 'package:flutter/material.dart';
import '../models/questionnaire_item.dart';
import '../services/questionnaire_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuestionnaireService _questionnaireService = QuestionnaireService();

  late Future<List<QuestionnaireItem>> _questionnaireFuture;
  late Future<String> _transcriptFuture;

  @override
  void initState() {
    super.initState();
    _questionnaireFuture = _questionnaireService.loadSampleQuestionnaire();
    _transcriptFuture = _questionnaireService.loadSampleTranscript();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamnesis AI Prototype'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QuestionnaireItem>>(
          future: _questionnaireFuture,
          builder: (context, questionnaireSnapshot) {
            if (questionnaireSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (questionnaireSnapshot.hasError) {
              return Text(
                'Error loading questionnaire: ${questionnaireSnapshot.error}',
              );
            }

            final items = questionnaireSnapshot.data ?? [];

            return FutureBuilder<String>(
              future: _transcriptFuture,
              builder: (context, transcriptSnapshot) {
                if (transcriptSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (transcriptSnapshot.hasError) {
                  return Text(
                    'Error loading transcript: ${transcriptSnapshot.error}',
                  );
                }

                final transcript = transcriptSnapshot.data ?? '';

                return ListView(
                  children: [
                    const Text(
                      'Loaded sample transcript',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(transcript),
                    const SizedBox(height: 24),
                    Text(
                      'Loaded questionnaire items: ${items.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...items.map(
                      (item) => Card(
                        child: ListTile(
                          title: Text('${item.linkId} - ${item.text}'),
                          subtitle: Text(item.answerOptions.join(', ')),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}