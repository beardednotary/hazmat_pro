import 'package:flutter_test/flutter_test.dart';

import 'package:hazmat_pro/main.dart';

void main() {
  testWidgets('App launches and shows the Placards tab', (WidgetTester tester) async {
    await tester.pumpWidget(const HazMatProApp());
    await tester.pump();

    expect(find.text('PLACARDS'), findsWidgets);
  });
}
