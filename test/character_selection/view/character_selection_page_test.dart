import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('CharacterSelectionPage', () {
    test('can be instantiated', () {
      expect(CharacterSelectionPage(), isA<CharacterSelectionPage>());
    });

    test('has a route', () {
      expect(CharacterSelectionPage.route(), isA<MaterialPageRoute<void>>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = CharacterSelectionPage();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });

      testWidgets('a CharacterSelecionView', (tester) async {
        await tester.pumpSubject(const CharacterSelectionPage());
        expect(find.byType(CharacterSelectionView), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelectionPage subject,
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
                child: subject,
              ),
            ),
          ),
        ),
      );
}
