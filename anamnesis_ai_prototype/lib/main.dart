import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AnamnesisApp());
}

class AnamnesisApp extends StatelessWidget {
  const AnamnesisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anamnesis AI Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
