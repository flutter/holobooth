import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('CharacterSelectionBody', () {
    test('can be instantiated', () {
      expect(CharacterSelectionBody(), isA<CharacterSelectionBody>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = CharacterSelectionBody();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
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
      pumpWidget(
        MediaQuery.fromWindow(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: PhotoboothTheme.standard,
              child: subject,
            ),
          ),
        ),
      );
}
