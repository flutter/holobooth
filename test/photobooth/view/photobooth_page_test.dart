// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class _FakeDragUpdate extends Fake implements DragUpdate {}

class _MockXFile extends Mock implements XFile {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(_FakePhotoboothEvent());
    registerFallbackValue(_FakeDragUpdate());
    registerFallbackValue(ResolutionPreset.max);
  });

  const cameraId = 1;
  late CameraPlatform cameraPlatform;
  late XFile xfile;
  late PhotoboothCameraImage image;

  setUp(() {
    xfile = _MockXFile();
    when(() => xfile.path).thenReturn('');

    cameraPlatform = _MockCameraPlatform();
    CameraPlatform.instance = cameraPlatform;

    final event = CameraInitializedEvent(
      cameraId,
      1,
      1,
      ExposureMode.auto,
      true,
      FocusMode.auto,
      true,
    );
    image = PhotoboothCameraImage(
      data: xfile.path,
      constraint: PhotoConstraint(
        width: event.previewWidth,
        height: event.previewHeight,
      ),
    );

    final cameraDescription = _MockCameraDescription();
    when(() => cameraPlatform.availableCameras())
        .thenAnswer((_) async => [cameraDescription]);
    when(
      () => cameraPlatform.createCamera(
        cameraDescription,
        any(),
      ),
    ).thenAnswer((_) async => 1);
    when(() => cameraPlatform.initializeCamera(cameraId))
        .thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.onCameraInitialized(cameraId)).thenAnswer(
      (_) => Stream.value(event),
    );
    when(() => CameraPlatform.instance.onDeviceOrientationChanged())
        .thenAnswer((_) => Stream.empty());
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.takePicture(any()))
        .thenAnswer((_) async => xfile);
    when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
    when(() => cameraPlatform.pausePreview(cameraId))
        .thenAnswer((_) => Future.value());
  });

  group('PhotoboothPage', () {
    test('is routable', () {
      expect(PhotoboothPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('displays a PhotoboothView', (tester) async {
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothView), findsOneWidget);
    });
  });

  group('PhotoboothView', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders PhotoboothView', (tester) async {
      final subject = PhotoboothView();
      await tester.pumpApp(subject, photoboothBloc: photoboothBloc);
      expect(find.byWidget(subject), findsOneWidget);
    });

    testWidgets('renders PhotoboothPreview', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pump(Duration.zero);
      expect(find.byType(PhotoboothPreview), findsOneWidget);
    });

    testWidgets('renders placeholder when initializing', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(() => cameraPlatform.availableCameras()).thenThrow(
        CameraException('', ''),
      );
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets(
        'renders camera access denied error '
        'when cameraPlatform throws CameraException '
        'with code "CameraAccessDenied"', (tester) async {
      when(() => cameraPlatform.availableCameras()).thenThrow(
        CameraException('CameraAccessDenied', ''),
      );
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_cameraAccessDenied')),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders camera not found error '
      'when cameraPlatform throws CameraException '
      'with code "cameraNotFound"',
      (tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(
          CameraException('cameraNotFound', ''),
        );
        await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
        await tester.pumpAndSettle();
        expect(
          find.byKey(Key('photoboothError_cameraNotFound')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
        'renders camera not supported error '
        'when cameraPlatform throws CameraException '
        'with code "cameraNotSupported"', (tester) async {
      when(() => cameraPlatform.availableCameras()).thenThrow(
        CameraException('cameraNotSupported', ''),
      );
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_cameraNotSupported')),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders unknown error '
        'when cameraPlatform throws CameraException '
        'with unknown code', (tester) async {
      when(() => cameraPlatform.availableCameras()).thenThrow(
        CameraException('', ''),
      );
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(Key('photoboothError_unknown')),
        findsOneWidget,
      );
    });

    testWidgets('renders preview when available', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(preview);

      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders landscape camera when orientation is landscape',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 400));
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(PhotoboothAspectRatio.landscape));
    });

    testWidgets(
        'adds PhotoCaptured with landscape aspect ratio '
        'when photo is snapped', (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );
      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();

      verify(
        () => photoboothBloc.add(
          PhotoCaptured(
            aspectRatio: PhotoboothAspectRatio.landscape,
            image: image,
          ),
        ),
      ).called(1);
    });

    testWidgets('renders portrait camera when orientation is portrait',
        (tester) async {
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(PhotoboothPage());
      await tester.pumpAndSettle();

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(PhotoboothAspectRatio.portrait));
    });

    testWidgets(
        'adds PhotoCaptured with portrait aspect ratio '
        'when photo is snapped', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );

      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();
      verify(
        () => photoboothBloc.add(
          PhotoCaptured(
            aspectRatio: PhotoboothAspectRatio.portrait,
            image: image,
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to StickersPage when photo is taken',
        (tester) async {
      await tester.pumpApp(PhotoboothView(), photoboothBloc: photoboothBloc);
      await tester.pumpAndSettle();

      final photoboothPreview = tester.widget<PhotoboothPreview>(
        find.byType(PhotoboothPreview),
      );

      photoboothPreview.onSnapPressed();

      await tester.pumpAndSettle();

      expect(find.byType(StickersPage), findsOneWidget);
    });
  });

  group('PhotoboothPreview', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    testWidgets('renders dash, sparky, dino, and android buttons',
        (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CharacterIconButton), findsNWidgets(4));
    });

    testWidgets('renders FlutterIconLink', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FlutterIconLink), findsOneWidget);
    });

    testWidgets('renders FirebaseIconLink', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(preview);

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      );
    });

    testWidgets('renders only dash when only dash is selected', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        findsOneWidget,
      );
      expect(find.byType(AnimatedDash), findsOneWidget);
    });

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.dash)],
        ),
      );
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(const Key('photoboothPreview_dash_draggableResizableAsset')),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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

    testWidgets('adds PhotoCharacterDragged when dragged', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: Assets.sparky)],
        ),
      );
      const preview = SizedBox();

      tester.setDisplaySize(Size(2500, 2500));
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();

      await tester.drag(
        find.byKey(
          const Key('photoboothPreview_sparky_draggableResizableAsset'),
        ),
        Offset(10, 10),
        warnIfMissed: false,
      );

      verify(
        () => photoboothBloc.add(any(that: isA<PhotoCharacterDragged>())),
      );
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(
            preview: preview,
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PortraitCharactersIconLayout), findsOneWidget);
    });

    testWidgets('tapping on dash button adds PhotoCharacterToggled',
        (tester) async {
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();

      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
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
      const preview = SizedBox();
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: PhotoboothPreview(preview: preview, onSnapPressed: () {}),
        ),
      );
      await tester.pump();
      expect(find.byType(CharactersCaption), findsNothing);
    });
  });
}
