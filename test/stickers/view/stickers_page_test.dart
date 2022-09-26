// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockStickersBloc extends MockBloc<StickersEvent, StickersState>
    implements StickersBloc {}

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _FakeDragUpdate extends Fake implements DragUpdate {}

class _MockPhotosRepository extends Mock implements PhotosRepository {}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockXFile extends Mock implements XFile {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(_FakePhotoboothEvent());
  });

  void setUpPhotoboothPage() {
    const cameraId = 1;
    final xfile = _MockXFile();
    when(() => xfile.path).thenReturn('');

    final cameraPlatform = _MockCameraPlatform();
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

    final cameraDescription = _MockCameraDescription();
    when(cameraPlatform.availableCameras)
        .thenAnswer((_) async => [cameraDescription]);
    when(
      () => cameraPlatform.createCamera(
        cameraDescription,
        ResolutionPreset.max,
      ),
    ).thenAnswer((_) async => 1);
    when(() => cameraPlatform.initializeCamera(cameraId))
        .thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.onCameraInitialized(cameraId)).thenAnswer(
      (_) => Stream.value(event),
    );
    when(() => CameraPlatform.instance.onDeviceOrientationChanged())
        .thenAnswer((_) => Stream.empty());
    when(() => cameraPlatform.takePicture(any()))
        .thenAnswer((_) async => xfile);
    when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
    when(() => cameraPlatform.pausePreview(cameraId))
        .thenAnswer((_) => Future.value());
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => <void>{});
  }

  setUp(setUpPhotoboothPage);

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('StickersPage', () {
    late PhotoboothBloc photoboothBloc;
    late PhotoboothCameraImage image;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      image = _MockPhotoboothCameraImage();
      when(() => image.data).thenReturn('');
      when(() => image.constraint).thenReturn(PhotoConstraint());
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          image: image,
        ),
      );
    });

    test('is routable', () {
      expect(StickersPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders StickersView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: photoboothBloc,
          child: StickersPage(),
        ),
      );
      expect(find.byType(StickersView), findsOneWidget);
    });
  });

  group('StickersView', () {
    late PhotoboothBloc photoboothBloc;
    late StickersBloc stickersBloc;
    late PhotoboothCameraImage image;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      image = _MockPhotoboothCameraImage();
      when(() => image.data).thenReturn('');
      when(() => image.constraint).thenReturn(PhotoConstraint());
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(image: image),
      );
      stickersBloc = _MockStickersBloc();
      when(() => stickersBloc.state).thenReturn(StickersState());
    });

    testWidgets('renders PhotoboothBackground', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(PhotoboothBackground), findsOneWidget);
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets('renders FlutterIconLink', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(FlutterIconLink), findsOneWidget);
    });

    testWidgets('renders FirebaseIconLink', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(FirebaseIconLink), findsOneWidget);
    });

    testWidgets('adds StickersDrawerToggled when OpenStickersButton tapped',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      tester
          .widget<OpenStickersButton>(find.byType(OpenStickersButton))
          .onPressed();
      verify(() => stickersBloc.add(StickersDrawerToggled())).called(1);
    });

    testWidgets(
        'does not display pulse animation '
        'once has been clicked', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(AnimatedPulse), findsOneWidget);
      tester
          .widget<AppTooltipButton>(
            find.byKey(Key('stickersView_openStickersButton_appTooltipButton')),
          )
          .onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedPulse), findsNothing);
    });

    testWidgets(
        'does not display DraggableResizableAsset when stickers is empty',
        (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(DraggableResizable), findsNothing);
    });

    testWidgets('displays DraggableResizableAsset when stickers is populated',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [
            PhotoAsset(id: '0', asset: MetaAssets.props.first),
            PhotoAsset(id: '1', asset: MetaAssets.props.last)
          ],
          image: image,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(DraggableResizable), findsNWidgets(2));
    });

    testWidgets('adds PhotoStickerDragged when sticker dragged',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );

      tester
          .widget<DraggableResizable>(find.byType(DraggableResizable))
          .onUpdate
          ?.call(_FakeDragUpdate());
      verify(
        () => photoboothBloc.add(any(that: isA<PhotoStickerDragged>())),
      );
    });

    testWidgets('tapping on retake + close does nothing', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              key: initialPage,
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: photoboothBloc),
                      BlocProvider.value(value: stickersBloc),
                    ],
                    child: StickersView(),
                  ),
                ),
              ),
              child: const SizedBox(),
            );
          },
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<IconButton>(find.byType(IconButton)).onPressed!();

      await tester.pumpAndSettle();

      verifyNever(() => photoboothBloc.add(const PhotoClearAllTapped()));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);
    });

    testWidgets('tapping on retake + cancel does nothing', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              key: initialPage,
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: photoboothBloc),
                      BlocProvider.value(value: stickersBloc),
                    ],
                    child: StickersView(),
                  ),
                ),
              ),
              child: const SizedBox(),
            );
          },
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed!();

      await tester.pumpAndSettle();

      verifyNever(() => photoboothBloc.add(const PhotoClearAllTapped()));
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);
    });

    testWidgets(
        'tapping on retake + confirm replaces route with PhotoboothPage'
        ' and clears props', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(PhotoboothPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('stickersPage_retake_appTooltipButton'),
      );
      tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

      await tester.pumpAndSettle();

      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed!();

      await tester.pumpAndSettle();

      verify(() => photoboothBloc.add(const PhotoClearAllTapped())).called(1);
      await tester.pumpAndSettle();

      expect(find.byType(StickersView), findsNothing);
      expect(find.byType(PhotoboothPage), findsOneWidget);
    });

    testWidgets('tapping next + cancel does not route to SharePage',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed!();

      await tester.pump();
      await tester.pump();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(SharePage), findsNothing);
    });

    testWidgets('tapping next + close does not route to SharePage',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<IconButton>(find.byType(IconButton)).onPressed!();

      await tester.pump();
      await tester.pump();

      expect(find.byType(StickersView), findsOneWidget);
      expect(find.byType(SharePage), findsNothing);
    });

    testWidgets('tapping next + confirm routes to SharePage', (tester) async {
      final photosRepository = _MockPhotosRepository();
      when(
        () => photosRepository.composite(
          width: any(named: 'width'),
          height: any(named: 'height'),
          data: any(named: 'data'),
          layers: [],
          aspectRatio: any(named: 'aspectRatio'),
        ),
      ).thenAnswer((_) async => Uint8List(0));

      await tester.pumpApp(
        BlocProvider.value(value: stickersBloc, child: StickersView()),
        photoboothBloc: photoboothBloc,
        photosRepository: photosRepository,
      );

      tester
          .widget<InkWell>(find.byKey(const Key('stickersPage_next_inkWell')))
          .onTap!();

      await tester.pump();

      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed!();

      await tester.pump();
      await tester.pump();

      expect(find.byType(StickersPage), findsNothing);
      expect(find.byType(SharePage), findsOneWidget);
    });

    testWidgets('does not display ClearStickersButton when stickers is empty',
        (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(ClearStickersButton), findsNothing);
    });

    testWidgets('displays ClearStickersButton when stickers is not empty',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(find.byType(ClearStickersButton), findsOneWidget);
    });

    testWidgets('shows ClearStickersDialog when ClearStickersButton is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );
      when(() => stickersBloc.state).thenReturn(
        StickersState(isDrawerActive: true),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      final clearStickersButton = tester.widget<ClearStickersButton>(
        find.byType(ClearStickersButton),
      );
      clearStickersButton.onPressed();
      await tester.pump();
      expect(find.byType(ClearStickersDialog), findsOneWidget);
    });

    testWidgets(
        'PhotoClearStickersTapped when ClearStickersConfirmButton is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      final clearStickersButton = tester.widget<ClearStickersButton>(
        find.byType(ClearStickersButton),
      );
      clearStickersButton.onPressed();
      await tester.pumpAndSettle();
      expect(find.byType(ClearStickersDialog), findsOneWidget);
      final confirmButton = find.byType(ClearStickersConfirmButton);
      await tester.ensureVisible(confirmButton);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      verify(() => photoboothBloc.add(PhotoClearStickersTapped())).called(1);
    });

    testWidgets('adds PhotoTapped when background photo is tapped',
        (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      final background = tester.widget<GestureDetector>(
        find.byKey(const Key('stickersView_background_gestureDetector')),
      );
      background.onTap?.call();
      verify(() => photoboothBloc.add(PhotoTapped())).called(1);
    });

    testWidgets(
        'adds PhotoDeleteSelectedStickerTapped '
        'when sticker selected is removed', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );

      tester
          .widget<DraggableResizable>(find.byType(DraggableResizable))
          .onDelete
          ?.call();

      verify(
        () => photoboothBloc.add(
          any(that: isA<PhotoDeleteSelectedStickerTapped>()),
        ),
      ).called(1);
    });

    testWidgets(
        'renders StickersCaption when shouldDisplayPropsReminder is true',
        (tester) async {
      when(() => stickersBloc.state).thenReturn(StickersState());
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(
        find.byKey(const Key('stickersPage_propsReminder_appTooltip')),
        findsOneWidget,
      );
    });

    testWidgets(
        'does not render StickersCaption when '
        'shouldDisplayPropsReminder is false', (tester) async {
      when(() => stickersBloc.state).thenReturn(
        StickersState(shouldDisplayPropsReminder: false),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: photoboothBloc),
            BlocProvider.value(value: stickersBloc),
          ],
          child: StickersView(),
        ),
      );
      expect(
        find.byKey(const Key('stickersPage_propsReminder_appTooltip')),
        findsNothing,
      );
    });
  });
}
