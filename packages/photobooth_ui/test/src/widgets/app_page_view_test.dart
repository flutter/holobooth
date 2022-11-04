// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AppPageView', () {
    const footerKey = Key('footer');
    const bodyKey = Key('body');
    const firstBackgroundKey = Key('firstBackground');
    const secondBackgroundKey = Key('secondBackground');
    const firstOverlayKey = Key('firstOverlay');
    const secondOverlayKey = Key('secondOverlayKey');

    testWidgets('renders body', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppPageView(
            footer: Container(key: footerKey),
            body: Container(
              height: 200,
              key: bodyKey,
            ),
          ),
        ),
      );

      expect(find.byKey(bodyKey), findsOneWidget);
    });

    testWidgets('renders footer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppPageView(
            footer: Container(key: footerKey),
            body: Container(
              height: 200,
              key: bodyKey,
            ),
          ),
        ),
      );

      expect(find.byKey(footerKey), findsOneWidget);
    });

    testWidgets('renders backgrounds', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppPageView(
            footer: Container(key: footerKey),
            body: Container(
              height: 200,
              key: bodyKey,
            ),
            backgrounds: [
              Container(key: firstBackgroundKey),
              Container(key: secondBackgroundKey),
            ],
          ),
        ),
      );

      expect(find.byKey(firstBackgroundKey), findsOneWidget);
      expect(find.byKey(secondBackgroundKey), findsOneWidget);
    });

    testWidgets('renders overlays', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppPageView(
            footer: Container(key: footerKey),
            body: Container(
              height: 200,
              key: bodyKey,
            ),
            backgrounds: [Container(key: firstBackgroundKey)],
            overlays: [
              Container(key: firstOverlayKey),
              Container(key: secondOverlayKey),
            ],
          ),
        ),
      );

      expect(find.byKey(firstOverlayKey), findsOneWidget);
      expect(find.byKey(secondOverlayKey), findsOneWidget);
    });
  });
}
