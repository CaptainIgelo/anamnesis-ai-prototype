import 'package:flutter_test/flutter_test.dart';
import 'package:anamnesis_ai_prototype/main.dart';

void main() {
  testWidgets('App starts and show title', (WidgetTester tester) async {
    await tester.pumpWidget(const AnamnesisApp());

    expect(find.text('Anamnesis AI Prototype'), findsOneWidget);
    expect(find.text('Project setup complete. Next step: transcript input and analysis flow.',), findsOneWidget);
  });
}
