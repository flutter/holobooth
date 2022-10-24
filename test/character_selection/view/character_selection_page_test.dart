import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

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
        await tester.pumpApp(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });

      testWidgets('a CharacterSelecionView', (tester) async {
        await tester.pumpApp(const CharacterSelectionPage());
        expect(find.byType(CharacterSelectionView), findsOneWidget);
      });
    });
  });
}
