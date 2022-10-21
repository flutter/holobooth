import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('CharacterSelector', () {
    test('can be instantiated', () {
      expect(CharacterSelector(), isA<CharacterSelector>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = CharacterSelector();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });

      testWidgets('dash', (tester) async {
        await tester.pumpSubject(CharacterSelector());
        expect(find.byKey(CharacterSelector.dashKey), findsOneWidget);
      });

      testWidgets('sparky', (tester) async {
        await tester.pumpSubject(CharacterSelector());
        expect(find.byKey(CharacterSelector.sparkyKey), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelector subject,
  ) =>
      pumpWidget(
        MediaQuery.fromWindow(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: PhotoboothTheme.medium,
              child: subject,
            ),
          ),
        ),
      );
}
