import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Anamnesis AI Prototype'),
            ),
            body: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'Project setup complete. Next step: transcript input and analysis flow.',
                ),
            ),
        );
    }
}