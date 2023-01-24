import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

class _MockRiveFileManager extends Mock implements RiveFileManager {}

void main() {
  group('PhotoboothBackground', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late PlatformHelper platformHelper;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
      platformHelper = _MockPlatformHelper();
    });

    testWidgets(
      'renders for all backgrounds in desktop',
      (WidgetTester tester) async {
        final riveFile = await RiveFile.asset(Assets.animations.bg00.path);
        final riveFileManager = _MockRiveFileManager();
        when(() => riveFileManager.getFile(any())).thenReturn(riveFile);
        when(() => riveFileManager.loadFile(any()))
            .thenAnswer((_) async => riveFile);
        for (final background in Background.values) {
          when(() => inExperienceSelectionBloc.state)
              .thenReturn(InExperienceSelectionState(background: background));
          when(() => platformHelper.isMobile).thenReturn(false);

          await tester.pumpApp(
            BlocProvider.value(
              value: inExperienceSelectionBloc,
              child: PhotoboothBackground(platformHelper: platformHelper),
            ),
            riveFileManager: riveFileManager,
          );
          expect(find.byKey(Key(background.name)), findsOneWidget);
        }
      },
    );

    testWidgets(
      'renders for all backgrounds in mobile',
      (WidgetTester tester) async {
        for (final background in Background.values) {
          when(() => inExperienceSelectionBloc.state)
              .thenReturn(InExperienceSelectionState(background: background));

          when(() => platformHelper.isMobile).thenReturn(true);
          await tester.pumpApp(
            BlocProvider.value(
              value: inExperienceSelectionBloc,
              child: PhotoboothBackground(platformHelper: platformHelper),
            ),
          );
          expect(find.byKey(Key(background.name)), findsOneWidget);
        }
      },
    );
  });
}
