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
    required this.size,
  });

  final CharacterSelectionView subject;
  final Size size;

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
            child: SizedBox.fromSize(
              size: size,
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
    testWidgets(
      'renders with shadows',
      (WidgetTester tester) async {
        //debugDisableShadows = false;
        await tester.pumpSubjectView(CharacterSelectionView());
        expect(find.byType(CharacterSpotlight), findsOneWidget);
        //debugDisableShadows = true;
      },
    );

    goldenTest(
      'character_selection_view_small',
      fileName: 'character_selection_view_small',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestScenario(
          name: 'character_selection_view_small',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            size: Size(PhotoboothBreakpoints.small, 850),
          ),
        );
      },
    );
    goldenTest(
      'character_selection_view_medium',
      fileName: 'character_selection_view_medium',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestScenario(
          name: 'character_selection_view_medium',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            size: Size(PhotoboothBreakpoints.medium, 1000),
          ),
        );
      },
    );

    goldenTest(
      'character_selection_view_large',
      fileName: 'character_selection_view_large',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestScenario(
          name: 'character_selection_view_large',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            size: Size(PhotoboothBreakpoints.large, 1200),
          ),
        );
      },
    );

    goldenTest(
      'character_selection_view_xlarge',
      fileName: 'character_selection_view_xlarge',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestScenario(
          name: 'character_selection_view_xlarge',
          child: _SubjectBuilder(
            subject: CharacterSelectionView(),
            size: Size(PhotoboothBreakpoints.large + 300, 1500),
          ),
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

extension on WidgetTester {
  Future<void> pumpSubjectView(
    CharacterSelectionView subject,
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
                child: Scaffold(body: subject),
              ),
            ),
          ),
        ),
      );
}
