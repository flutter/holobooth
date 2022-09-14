// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockPhotosRepository extends Mock implements PhotosRepository {}

class _MockXFile extends Mock implements XFile {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PhotoboothCameraImage image;

  late PhotosRepository photosRepository;
  late PhotoboothBloc photoboothBloc;
  late ShareBloc shareBloc;
  late XFile file;

  setUpAll(() {
    registerFallbackValue(_FakePhotoboothEvent());
    registerFallbackValue(FakeShareEvent());
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

  setUp(() {
    file = _MockXFile();
    image = _MockPhotoboothCameraImage();
    when(() => image.data).thenReturn('');
    when(() => image.constraint).thenReturn(PhotoConstraint());

    photosRepository = _MockPhotosRepository();
    when(
      () => photosRepository.composite(
        width: image.constraint.width.floor(),
        height: image.constraint.height.floor(),
        data: image.data,
        layers: [],
        aspectRatio: any(named: 'aspectRatio'),
      ),
    ).thenAnswer((_) async => Uint8List.fromList([]));
    photoboothBloc = _MockPhotoboothBloc();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));

    shareBloc = MockShareBloc();
    whenListen(
      shareBloc,
      Stream.fromIterable([ShareState()]),
      initialState: ShareState(),
    );

    setUpPhotoboothPage();
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('SharePage', () {
    test('is routable', () {
      expect(SharePage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders a ShareView', (tester) async {
      await tester.pumpApp(
        SharePage(),
        photosRepository: photosRepository,
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareView), findsOneWidget);
    });
  });

  group('ShareView', () {
    testWidgets('displays a ShareBackground', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBackground), findsOneWidget);
    });

    testWidgets('displays a ShareBody', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });

    testWidgets('displays a WhiteFooter', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      await tester.ensureVisible(find.byType(WhiteFooter, skipOffstage: false));
    });

    testWidgets('displays a ShareRetakeButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(
        find.byKey(const Key('sharePage_retake_appTooltipButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareProgressOverlay', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareProgressOverlay), findsOneWidget);
    });
  });

  group('ShareBody', () {
    setUp(() {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          bytes: Uint8List(0),
          file: file,
        ),
      );
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(child: ShareBody()),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoIndicator', (tester) async {
      tester.setDisplaySize(Size(PhotoboothBreakpoints.medium, 800));
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(AnimatedPhotoIndicator), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoboothPhoto', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(AnimatedPhotoboothPhoto), findsOneWidget);
    });

    testWidgets('displays a ShareHeading', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(
        find.byType(ShareHeading),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays a ShareSuccessHeading '
        'when uploadStatus is success', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(
        find.byType(ShareSuccessHeading),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays a ShareErrorHeading '
        'when compositeStatus is failure', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.failure,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(
        find.byType(ShareErrorHeading),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareSubheading', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(ShareSubheading), findsOneWidget);
    });

    testWidgets(
        'displays a ShareSuccessSubheading '
        'when uploadStatus is success', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(ShareSuccessSubheading), findsOneWidget);
    });

    testWidgets(
        'displays a ShareErrorSubheading '
        'when compositeStatus is failure', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.failure,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(ShareErrorSubheading), findsOneWidget);
    });

    testWidgets(
        'displays a ShareSuccessCaption '
        'when uploadStatus is success', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(ShareSuccessCaption), findsOneWidget);
    });

    testWidgets(
        'displays a ShareCopyableLink '
        'when uploadStatus is success', (tester) async {
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
          file: file,
        ),
      );
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(find.byType(ShareCopyableLink), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );

      expect(
        find.byKey(const Key('sharePage_retake_appTooltipButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(DownloadButton), findsOneWidget);
    });

    testWidgets('displays a GoToGoogleIOButton', (tester) async {
      await tester.pumpApp(
        ShareView(),
        photoboothBloc: photoboothBloc,
        shareBloc: shareBloc,
      );
      expect(find.byType(GoToGoogleIOButton), findsOneWidget);
    });

    group('GoToGoogleIOButton', () {
      late UrlLauncherPlatform mock;

      setUp(() {
        mock = _MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => mock.launchUrl(any(), any()),
        ).thenAnswer((_) async => true);
      });

      setUpAll(() {
        registerFallbackValue(_FakeLaunchOptions());
      });

      testWidgets('opens link when tapped', (tester) async {
        tester.setDisplaySize(Size(2500, 2500));
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );
        await tester.ensureVisible(
          find.byType(
            GoToGoogleIOButton,
            skipOffstage: false,
          ),
        );
        await tester.tap(find.byType(GoToGoogleIOButton, skipOffstage: false));

        verify(
          () => mock.launchUrl(googleIOExternalLink, any()),
        ).called(1);
      });
    });

    group('RetakeButton', () {
      testWidgets(
          'tapping on retake button + close '
          'does not go back to PhotoboothPage', (tester) async {
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );

        final retakeButtonFinder = find.byKey(
          const Key('sharePage_retake_appTooltipButton'),
        );
        tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

        await tester.pumpAndSettle();

        tester.widget<IconButton>(find.byType(IconButton)).onPressed!();

        await tester.pumpAndSettle();

        expect(retakeButtonFinder, findsOneWidget);
        expect(find.byType(PhotoboothPage), findsNothing);

        verifyNever(() => photoboothBloc.add(PhotoClearAllTapped()));
      });

      testWidgets(
          'tapping on retake button + cancel '
          'does not go back to PhotoboothPage', (tester) async {
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );

        final retakeButtonFinder = find.byKey(
          const Key('sharePage_retake_appTooltipButton'),
        );
        tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

        await tester.pumpAndSettle();

        final cancelButtonFinder = find.byKey(
          const Key('sharePage_retakeCancel_elevatedButton'),
        );

        tester.widget<OutlinedButton>(cancelButtonFinder).onPressed!();

        await tester.pumpAndSettle();

        expect(retakeButtonFinder, findsOneWidget);
        expect(find.byType(PhotoboothPage), findsNothing);

        verifyNever(() => photoboothBloc.add(PhotoClearAllTapped()));
      });

      testWidgets(
          'tapping on retake button + confirm goes back to PhotoboothPage',
          (tester) async {
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );

        final retakeButtonFinder = find.byKey(
          const Key('sharePage_retake_appTooltipButton'),
        );
        tester.widget<AppTooltipButton>(retakeButtonFinder).onPressed();

        await tester.pumpAndSettle();

        final confirmButtonFinder = find.byKey(
          const Key('sharePage_retakeConfirm_elevatedButton'),
        );

        tester.widget<ElevatedButton>(confirmButtonFinder).onPressed!();

        await tester.pumpAndSettle();

        expect(retakeButtonFinder, findsNothing);
        expect(find.byType(PhotoboothPage), findsOneWidget);

        verify(() => photoboothBloc.add(PhotoClearAllTapped())).called(1);
      });
    });

    group('ResponsiveLayout', () {
      testWidgets('displays a DesktopButtonsLayout', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );
        expect(find.byType(DesktopButtonsLayout), findsOneWidget);
      });

      testWidgets('displays a MobileButtonsLayout', (tester) async {
        tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
        await tester.pumpApp(
          ShareView(),
          photoboothBloc: photoboothBloc,
          shareBloc: shareBloc,
        );
        expect(find.byType(MobileButtonsLayout), findsOneWidget);
      });
    });
  });
}
