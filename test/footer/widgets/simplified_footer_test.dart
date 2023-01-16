import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SimplifiedFooter', () {
    testWidgets(
      'render elements on small screen size',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(SimplifiedFooter());
        expect(find.byType(FlutterIconLink), findsOneWidget);
        expect(find.byType(FirebaseIconLink), findsOneWidget);
        expect(find.byType(TensorflowIconLink), findsOneWidget);
      },
    );

    testWidgets(
      'render elements on large screen size',
      (WidgetTester tester) async {
        tester.setDisplaySize(const Size(HoloboothBreakpoints.large, 800));
        await tester.pumpApp(SimplifiedFooter());
        expect(find.byType(FlutterIconLink), findsOneWidget);
        expect(find.byType(FirebaseIconLink), findsOneWidget);
        expect(find.byType(TensorflowIconLink), findsOneWidget);
      },
    );
  });
}
