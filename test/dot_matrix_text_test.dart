import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dot_matrix_text/dot_matrix_text.dart';

void main() {
  testWidgets('DotMatrixText renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: DotMatrixText(
              text: 'Test',
              ledSize: 4,
              ledSpacing: 2,
              blankLedColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              mirrorMode: false,
              flickerMode: false,
              invertColors: false,
            ),
          ),
        ),
      ),
    );

    // Verifying if DotMatrixText is present in the widget tree
    expect(find.byType(DotMatrixText), findsOneWidget);

    // Verifying the text is 'Test'
    final textWidget = tester.widget<DotMatrixText>(find.byType(DotMatrixText));
    expect(textWidget.text, 'Test');

    // Verifying the text style
    expect(textWidget.textStyle.fontSize, 100);
    expect(textWidget.textStyle.fontWeight, FontWeight.bold);
    expect(textWidget.textStyle.color, Colors.red);
  });

  testWidgets('DotMatrixText mirrorMode works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: DotMatrixText(
              text: 'Mirror',
              ledSize: 4,
              ledSpacing: 2,
              blankLedColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              mirrorMode: true,
              flickerMode: false,
              invertColors: false,
            ),
          ),
        ),
      ),
    );

    // Verifying if DotMatrixText is present in the widget tree
    expect(find.byType(DotMatrixText), findsOneWidget);

    // Verifying the mirrorMode is true
    final textWidget = tester.widget<DotMatrixText>(find.byType(DotMatrixText));
    expect(textWidget.mirrorMode, true);
  });

  testWidgets('DotMatrixText flickerMode works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: DotMatrixText(
              text: 'Flicker',
              ledSize: 4,
              ledSpacing: 2,
              blankLedColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              mirrorMode: false,
              flickerMode: true,
              invertColors: false,
            ),
          ),
        ),
      ),
    );

    // Verifying if DotMatrixText is present in the widget tree
    expect(find.byType(DotMatrixText), findsOneWidget);

    // Verifying the flickerMode is true
    final textWidget = tester.widget<DotMatrixText>(find.byType(DotMatrixText));
    expect(textWidget.flickerMode, true);
  });

  testWidgets('DotMatrixText invertColors works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: DotMatrixText(
              text: 'Invert',
              ledSize: 4,
              ledSpacing: 2,
              blankLedColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              mirrorMode: false,
              flickerMode: false,
              invertColors: true,
            ),
          ),
        ),
      ),
    );

    // Verifying if DotMatrixText is present in the widget tree
    expect(find.byType(DotMatrixText), findsOneWidget);

    // Verifying the invertColors is true
    final textWidget = tester.widget<DotMatrixText>(find.byType(DotMatrixText));
    expect(textWidget.invertColors, true);
  });
}
