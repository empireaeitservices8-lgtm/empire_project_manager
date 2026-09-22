import 'package:flutter_test/flutter_test.dart';
import 'package:empire_project_manager/main.dart';

void main() {
  testWidgets('App renders login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EmpireProjectManagerApp());
    expect(find.text('EMPIRE'), findsOneWidget);
    expect(find.text('ENTER WORKSPACE'), findsOneWidget);
  });
}
