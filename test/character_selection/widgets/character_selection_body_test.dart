import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
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

      testWidgets('a FloatingActionButon', (tester) async {
        await tester.pumpSubject(CharacterSelectionBody());
        final finder = find.byType(FloatingActionButton);
        await tester.ensureVisible(finder);
        expect(finder, findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets(
        'to MultipleCapturePage '
        'when FloatingActionButton is pressed',
        (tester) async {
          await tester.pumpSubject(CharacterSelectionBody());
          final finder = find.byType(FloatingActionButton);
          await tester.ensureVisible(finder);
          await tester.tap(finder);
          await tester.pumpAndSettle();
          expect(find.byType(MultipleCapturePage), findsOneWidget);
        },
      );
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
            child: Localizations(
              locale: Locale('en'),
              delegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              child: Theme(
                data: PhotoboothTheme.standard,
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => SingleChildScrollView(child: subject),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
