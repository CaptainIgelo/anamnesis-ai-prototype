import 'package:flutter_test/flutter_test.dart';
import 'package:anamnesis_ai_prototype/main.dart';

void main() {
  testWidgets('App starts and loads sample content', (WidgetTester tester) async {
    await tester.pumpWidget(const AnamnesisApp());
    await tester.pumpAndSettle();

    expect(find.text('Anamnesis AI Prototype'), findsOneWidget);
    expect(find.text('Loaded sample transcript'), findsOneWidget);
    expect(find.textContaining('Loaded questionnaire items:'), findsOneWidget);
  });
}