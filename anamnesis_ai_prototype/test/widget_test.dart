import 'package:anamnesis_ai_prototype/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows transcript input and analysis section', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AnamnesisApp());
    await tester.pumpAndSettle();

    expect(find.text('Anamnese KI Prototyp'), findsOneWidget);
    expect(find.text('Interview-Transkript'), findsOneWidget);
    expect(find.text('Analyseergebnisse'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byTooltip('Analysieren'), findsOneWidget);
    expect(find.byTooltip('CSV exportieren'), findsOneWidget);
  });
}
