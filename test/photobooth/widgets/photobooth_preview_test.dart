// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

void main() {
  group('PhotoboothPreview', () {
    late PhotoboothBloc photoboothBloc;

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothEvent());
    });

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders dash, sparky, dino, and android buttons',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CharacterIconButton), findsNWidgets(4));
    });

    testWidgets('renders FlutterIconLink', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FlutterIconLink), findsOneWidget);
    });

    testWidgets('renders FirebaseIconLink', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FirebaseIconLink), findsOneWidget);
    });

    testWidgets('renders only android when only android is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedAndroid), findsOneWidget);
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_android_draggableResizableAsset'),
        ),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      ).called(1);
    });

    testWidgets('renders only dash when only dash is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        findsOneWidget,
      );
      expect(find.byType(AnimatedDash), findsOneWidget);
    });

    testWidgets('renders only sparky when only sparky is selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [
            PhotoAsset(id: '0', asset: Assets.sparky),
          ],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedSparky), findsOneWidget);
    });

    testWidgets('renders only dino when only dino is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dino)],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          const Key('photoboothPreview_dino_draggableResizableAsset'),
        ),
        findsOneWidget,
      );
      expect(find.byType(AnimatedDino), findsOneWidget);
    });

    testWidgets('renders dash, sparky, dino, and android when all are selected',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [
            PhotoAsset(id: '0', asset: Assets.android),
            PhotoAsset(id: '1', asset: Assets.dash),
            PhotoAsset(id: '2', asset: Assets.sparky),
            PhotoAsset(id: '3', asset: Assets.dino),
          ],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(find.byType(DraggableResizable), findsNWidgets(4));
      expect(find.byType(AnimatedAndroid), findsOneWidget);
      expect(find.byType(AnimatedDash), findsOneWidget);
      expect(find.byType(AnimatedDino), findsOneWidget);
      expect(find.byType(AnimatedSparky), findsOneWidget);
    });

    testWidgets(
        'displays a LandscapeCharactersIconLayout '
        'when orientation is landscape', (tester) async {
      tester.setDisplaySize(landscapeDisplaySize);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(
            preview: SizedBox(),
            onSnapPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LandscapeCharactersIconLayout), findsOneWidget);
    });

    testWidgets(
        'displays a PortraitCharactersIconLayout '
        'when orientation is portrait', (tester) async {
      tester.setDisplaySize(portraitDisplaySize);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PortraitCharactersIconLayout), findsOneWidget);
    });

    testWidgets('tapping on dash button adds PhotoCharacterToggled',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('photoboothView_dash_characterIconButton'),
        ),
      );
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.dash),
        ),
      ).called(1);
    });

    testWidgets('tapping on sparky button adds PhotoCharacterToggled',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('photoboothView_sparky_characterIconButton'),
        ),
      );
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.sparky),
        ),
      ).called(1);
    });

    testWidgets('tapping on android button adds PhotoCharacterToggled',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('photoboothView_android_characterIconButton'),
        ),
      );
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.android),
        ),
      ).called(1);
    });

    testWidgets('tapping on dino button adds PhotoCharacterToggled',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('photoboothView_dino_characterIconButton'),
        ),
      );
      expect(tester.takeException(), isNull);
      verify(
        () => photoboothBloc.add(
          PhotoCharacterToggled(character: Assets.dino),
        ),
      ).called(1);
    });

    testWidgets('tapping on background adds PhotoTapped', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('photoboothPreview_background_gestureDetector'),
        ),
      );
      expect(tester.takeException(), isNull);
      verify(() => photoboothBloc.add(PhotoTapped())).called(1);
    });

    testWidgets(
        'renders CharactersCaption on mobile when no character is selected',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CharactersCaption), findsOneWidget);
    });

    testWidgets(
        'does not render CharactersCaption on mobile when '
        'any character is selected', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.android)],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: SizedBox(), onSnapPressed: () {}),
        ),
      );
      await tester.pump();
      expect(find.byType(CharactersCaption), findsNothing);
    });
  });
}
