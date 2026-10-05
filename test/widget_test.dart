import 'package:flutter_test/flutter_test.dart';

import 'package:digital_pet/main.dart';

void main() {
  testWidgets('Digital Pet basic UI test', (WidgetTester tester) async {
    // Build the Digital Pet app
    await tester.pumpWidget(const MyApp());

    // Verify the main Digital Pet UI
    expect(find.text('Digital Pet'), findsOneWidget);
    expect(find.text('Pip'), findsOneWidget);
    expect(find.text('Happiness: 50'), findsOneWidget);
    expect(find.text('Hunger: 50'), findsOneWidget);

    // Verify buttons
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });
}