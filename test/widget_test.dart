import 'package:flutter_test/flutter_test.dart';
import 'package:artisan/main.dart'; // Adjust path if needed

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Test base initialization
    expect(find.byType(MyApp), findsOneWidget);
  });
}
