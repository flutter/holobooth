import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _SubjectBuilder extends StatelessWidget {
  const _SubjectBuilder({
    required this.subject,
    required this.height,
    required this.width,
  });

  final CharacterSelectionView subject;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromWindow(
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
            child: SizedBox(
              height: height,
              width: width,
              child: subject,
            ),
          ),
        ),
      ),
    );
  }
}

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

  group('CharacterSelectionView', () {
    goldenTest(
      'CharacterSelectionView',
      fileName: 'character_selection_view',
      builder: () {
        final scenarioSmall = GoldenTestScenario(
          name: 'small',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            height: 700,
            width: PhotoboothBreakpoints.small,
          ),
        );
        final scenarioMedium = GoldenTestScenario(
          name: 'medium',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            height: 800,
            width: PhotoboothBreakpoints.medium,
          ),
        );
        final scenarioLarge = GoldenTestScenario(
          name: 'large',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            height: 1000,
            width: PhotoboothBreakpoints.large,
          ),
        );
        final scenarioXLarge = GoldenTestScenario(
          name: 'xlarge',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            height: 1300,
            width: PhotoboothBreakpoints.large + 100,
          ),
        );
        return GoldenTestGroup(
          children: [
            scenarioSmall,
            scenarioMedium,
            scenarioLarge,
            scenarioXLarge,
          ],
        );
      },
    );
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
