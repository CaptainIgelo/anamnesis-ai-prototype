import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/analysis_service.dart';
import '../services/questionnaire_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuestionnaireService _questionnaireService = QuestionnaireService();
  final AnalysisService _analysisService = AnalysisService();
  final TextEditingController _transcriptController = TextEditingController();

  bool _isLoading = true;
  bool _isAnalyzing = false;
  List<AnalysisResult> _results = [];

  @override
  void initState() {
    super.initState();
    _loadSampleTranscript();
  }

  Future<void> _loadSampleTranscript() async {
    final transcript = await _questionnaireService.loadSampleTranscript();

    setState(() {
      _transcriptController.text = transcript;
      _isLoading = false;
    });
  }

  Future<void> _analyzeTranscript() async {
    setState(() {
      _isAnalyzing = true;
    });

    final results = await _analysisService.analyzeTranscript(
      _transcriptController.text,
    );

    setState(() {
      _results = results;
      _isAnalyzing = false;
    });
  }

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamnesis AI Prototype'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const Text(
                    'Transcript input',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _transcriptController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Paste or enter the interview transcript here',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isAnalyzing ? null : _analyzeTranscript,
                    child: _isAnalyzing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Analyze transcript'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Analysis results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_results.isEmpty)
                    const Text('No analysis results yet.')
                  else
                    ..._results.map(
                      (result) => Card(
                        child: ListTile(
                          title: Text('${result.linkId} - ${result.question}'),
                          subtitle: Text(
                            'Answer: ${result.answer}\nConfidence: ${result.confidence}',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}