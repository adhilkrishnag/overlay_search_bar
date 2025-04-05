import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlay_search_bar/overlay_search_bar.dart';

void main() {
  testWidgets('OverlaySearchBar renders with custom overlay decoration',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OverlaySearchBar(
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(10.0),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            hintText: 'Test Search',
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Test Search'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.text('Overlay Content'), findsOneWidget);
  });
}
