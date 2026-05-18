import 'package:anamnesis_ai_prototype/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows transcript input and analysis section', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AnamnesisApp());
    await tester.pumpAndSettle();

    expect(find.text('Anamnesis AI Prototype'), findsOneWidget);
    expect(find.text('Transcript input'), findsOneWidget);
    expect(find.text('Analysis results'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byTooltip('Analyze'), findsOneWidget);
    expect(find.byTooltip('Export CSV'), findsOneWidget);
  });
}
