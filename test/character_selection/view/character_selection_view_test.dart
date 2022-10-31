import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelectionView', () {
    test('can be instantiaded', () {
      expect(CharacterSelectionView(), isA<CharacterSelectionView>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = CharacterSelectionView();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });

      testWidgets('a CharacterSelectionBackground', (tester) async {
        await tester.pumpSubject(const CharacterSelectionView());
        expect(find.byType(CharacterSelectionBackground), findsOneWidget);
      });

      testWidgets('a CharacterSelectionBody', (tester) async {
        await tester.pumpSubject(const CharacterSelectionView());
        expect(find.byType(CharacterSelectionBody), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelectionView subject,
  ) =>
      pumpApp(Scaffold(body: subject));
}
