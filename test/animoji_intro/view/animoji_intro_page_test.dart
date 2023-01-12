import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/animoji_intro/animoji_intro.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AnimojiIntroPage', () {
    testWidgets('renders AnimojiIntroView', (tester) async {
      await tester.pumpApp(AnimojiIntroPage());
      expect(find.byType(AnimojiIntroView), findsOneWidget);
    });
  });

  group('AnimojiIntroView', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimojiIntroBackground), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byKey(Key('animojiIntro_subheading_text')), findsOneWidget);
    });

    testWidgets('renders animation', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimatedSprite), findsOneWidget);
      final widget = tester.widget<AnimatedSprite>(find.byType(AnimatedSprite));
      expect(widget.sprites.asset, equals('holobooth_avatar.png'));
    });

    testWidgets('renders next button', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(NextButton), findsOneWidget);
    });

    testWidgets('tapping on next button navigates to PhotoBoothPage',
        (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      await tester.ensureVisible(find.byType(NextButton));
      await tester.pump();
      await tester.tap(
        find.byType(
          NextButton,
          skipOffstage: false,
        ),
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(PhotoBoothPage), findsOneWidget);
      expect(find.byType(AnimojiIntroPage), findsNothing);
    });
  });
}
