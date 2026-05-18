import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/analysis_result.dart';
import '../services/openai_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OpenAiService _openAiService = OpenAiService();
  final TextEditingController _transcriptController = TextEditingController();

  bool _isLoading = true;
  bool _isAnalyzing = false;
  String? _errorMessage;
  List<AnalysisResult> _results = [];

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Future<void> _analyzeTranscript() async {
    final transcript = _transcriptController.text.trim();

    if (transcript.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte zuerst ein Transkript einfügen.';
        _results = [];
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final results = await _openAiService.analyzeTranscript(transcript);

      if (!mounted) return;

      setState(() {
        _results = results;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _results = [];
        _errorMessage =
            'Analyse fehlgeschlagen. Bitte später erneut versuchen. ';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  String _escapeCsv(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  Future<void> _exportCsv() async {
    if (_results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Ergebnisse zum Exprotieren vorhanden.'),
        ),
      );
      return;
    }

    final rows = <List<String>>[
      ['linkId', 'answer'],
      ..._results.map((r) => [r.linkId, r.answer]),
    ];

    final csvString = rows
        .map((row) => row.map(_escapeCsv).join(','))
        .join('\n');

    final fileName =
        'anamnesis_export_${DateTime.now().millisecondsSinceEpoch}.csv';

    if (kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              utf8.encode(csvString),
              mimeType: 'text/csv',
              name: fileName,
            ),
          ],
          text: 'Anamnese CSV-Export',
        ),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvString);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Anamnese CSV-Export'),
    );
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
        title: const Text('Anamnese KI Prototyp'),
        actions: [
          IconButton(
            onPressed: _results.isEmpty ? null : _exportCsv,
            icon: const Icon(Icons.share),
            tooltip: 'CSV exportieren',
          ),
          IconButton(
            onPressed: _isAnalyzing ? null : _analyzeTranscript,
            icon: const Icon(Icons.check),
            tooltip: 'Analysieren',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const Text(
                    'Interview-Transkript',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _transcriptController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'hier Transkript einfügen...',
                    ),
                  ),
                  if (_isAnalyzing) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Analyseergebnisse',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_results.isEmpty)
                    const Text('Noch keine Analyseergebnisse vorhanden.')
                  else
                    ..._results.map(
                      (result) => Card(
                        child: ListTile(
                          title: Text(result.linkId),
                          subtitle: Text(result.answer),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
