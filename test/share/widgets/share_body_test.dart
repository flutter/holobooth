// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _FakePhotoboothEvent extends Fake implements PhotoboothEvent {}

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockXFile extends Mock implements XFile {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

class _FakeCameraOptions extends Fake implements CameraOptions {}

void main() {
  group('ShareBody', () {
    late PhotoboothBloc photoboothBloc;
    late ShareBloc shareBloc;
    late XFile file;
    const width = 1;
    const height = 1;
    const data = '';
    const image = CameraImage(width: width, height: height, data: data);

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothEvent());
      registerFallbackValue(FakeShareEvent());
      registerFallbackValue(_FakeCameraOptions());
    });

    setUp(() {
      file = _MockXFile();
      shareBloc = MockShareBloc();
      when(() => shareBloc.state).thenReturn(
        ShareState(
          compositeStatus: ShareStatus.success,
          bytes: Uint8List(0),
          file: file,
        ),
      );
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state)
          .thenReturn(PhotoboothState(image: image));
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
