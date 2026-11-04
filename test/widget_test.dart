import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:lab3_selab/main.dart';

void main() {
  testWidgets('Jitket Cafech app loads successfully',
      (WidgetTester tester) async {
    // Launch the café application.
    await tester.pumpWidget(const JitketCafechApp());

    // Allow the first frame to render.
    await tester.pump();

    // Verify that the application is displayed.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    // Verify that the café branding is displayed.
    expect(find.text('Jitket Cafech'), findsWidgets);
  });
}