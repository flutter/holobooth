import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionBody', () {
    test('can be instantiated', () {
      expect(CharacterSelectionBody(), isA<CharacterSelectionBody>());
    });

    group('renders', () {
      // TODO(oscar): add GoldenTest once assets are finalized
      testWidgets('for PhotoboothBreakpoints.small', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));
        final subject = CharacterSelectionBody();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
        final finder = find.byWidgetPredicate(
          (w) => w is CharacterSelector && w.viewportFraction == 0.55,
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('for PhotoboothBreakpoints.medium', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.medium, 800));
        final subject = CharacterSelectionBody();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
        final finder = find.byWidgetPredicate(
          (w) => w is CharacterSelector && w.viewportFraction == 0.3,
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('for PhotoboothBreakpoints.large', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));
        final subject = CharacterSelectionBody();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
        final finder = find.byWidgetPredicate(
          (w) => w is CharacterSelector && w.viewportFraction == 0.2,
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('for greater than PhotoboothBreakpoints.large',
          (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));
        final subject = CharacterSelectionBody();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
        final finder = find.byWidgetPredicate(
          (w) => w is CharacterSelector && w.viewportFraction == 0.2,
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('title', (tester) async {
        await tester.pumpSubject(CharacterSelectionBody());
        expect(find.text('Choose your character'), findsOneWidget);
      });

      testWidgets('subtitle', (tester) async {
        await tester.pumpSubject(CharacterSelectionBody());
        expect(find.text('You can change them later'), findsOneWidget);
      });

      testWidgets('character selector', (tester) async {
        await tester.pumpSubject(CharacterSelectionBody());
        expect(find.byType(CharacterSelector), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelectionBody subject,
  ) =>
      pumpApp(Scaffold(body: SingleChildScrollView(child: subject)));
}
