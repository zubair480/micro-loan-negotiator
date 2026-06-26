import 'package:flutter_test/flutter_test.dart';
import 'package:negotia_ai/main.dart';

void main() {
  testWidgets('App starts with landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NegotiaAIApp());
    expect(find.text('Negotia AI'), findsOneWidget);
  });
}
