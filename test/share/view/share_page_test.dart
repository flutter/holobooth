import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  group('SharePage', () {
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];
    test('is routable', () {
      expect(SharePage.route(images), isA<AppPageRoute<void>>());
    });

    testWidgets('renders ShareBackground', (tester) async {
      await tester.pumpApp(SharePage(images: images));
      expect(find.byType(ShareBackground), findsOneWidget);
    });
  });

  group('ShareView', () {
    late ShareBloc shareBloc;
    late UrlLauncherPlatform mock;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      shareBloc = _MockShareBloc();

      when(() => shareBloc.state).thenReturn(ShareState());
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
    });

    setUpAll(() {
      registerFallbackValue(LaunchOptions());
    });
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];

    testWidgets('contains a ShareBody', (tester) async {
      await tester.pumpSubject(
        ShareView(
          images: images,
        ),
        ShareBloc(),
      );
      expect(find.byType(ShareBody), findsOneWidget);
    });

    testWidgets('opens the correct twitter url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareUrl: ShareUrl.twitter,
            shareStatus: ShareStatus.success,
            twitterShareUrl: 'http://twitter.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(
          images: images,
        ),
        ShareBloc(),
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://twitter.com', any()),
      ).called(1);
    });

    testWidgets('opens the correct facebook url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareUrl: ShareUrl.facebook,
            shareStatus: ShareStatus.success,
            facebookShareUrl: 'http://facebook.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(
          images: images,
        ),
        ShareBloc(),
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://facebook.com', any()),
      ).called(1);
    });

    testWidgets('opens the explicit share url when ShareStatus is successful',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(),
          ShareState(
            shareStatus: ShareStatus.success,
            explicitShareUrl: 'http://google.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(
          images: images,
        ),
        ShareBloc(),
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://google.com', any()),
      ).called(1);
    });

    testWidgets('opens the correct url when a different button is pressed',
        (tester) async {
      whenListen(
        shareBloc,
        Stream.fromIterable([
          ShareState(
            shareUrl: ShareUrl.facebook,
            shareStatus: ShareStatus.success,
          ),
          ShareState(
            shareUrl: ShareUrl.twitter,
            shareStatus: ShareStatus.success,
            twitterShareUrl: 'http://twitter.com',
          )
        ]),
      );
      await tester.pumpSubject(
        ShareView(
          images: images,
        ),
        ShareBloc(),
      );
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('http://twitter.com', any()),
      ).called(1);
    });
  });

  group('ShareBody', () {
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];
    testWidgets('displays a AnimatedPhotoIndicator', (tester) async {
      tester.setDisplaySize(Size(PhotoboothBreakpoints.medium, 800));
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(AnimatedPhotoIndicator), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoboothPhoto in medium layout',
        (tester) async {
      tester.setDisplaySize(Size(PhotoboothBreakpoints.medium, 800));
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(AnimatedPhotoboothPhoto), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoboothPhoto in XLarge layout',
        (tester) async {
      tester.setDisplaySize(Size(PhotoboothBreakpoints.large, 800));
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(AnimatedPhotoboothPhoto), findsOneWidget);
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(DownloadButton), findsOneWidget);
    });

    testWidgets('displays a TakeANewPhoto button', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(TakeANewPhoto), findsOneWidget);
    });
  });

  group('ResponsiveLayout', () {
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];

    testWidgets('displays a DesktopButtonsLayout when layout is large',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(DesktopButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a MobileButtonsLayout when layout is small',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(MobileButtonsLayout), findsOneWidget);
    });
  });

  group('TakeANewPhoto button', () {
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];

    testWidgets('Navigates to photobooth when pressed', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      await tester
          .ensureVisible(find.byKey(Key('sharePage_newPhotoButtonKey')));
      await tester.tap(find.byKey(Key('sharePage_newPhotoButtonKey')));
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      expect(find.byType(PhotoBoothPage), findsOneWidget);
    });
  });

  group('DownloadButton', () {
    final images = [
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage(),
      FakePhotoboothCameraImage()
    ];

    testWidgets('invoked when pressed', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      await tester
          .ensureVisible(find.byKey(Key('sharePage_downloadButtonkey')));
      await tester.tap(find.byKey(Key('sharePage_downloadButtonkey')));
      // TODO(laura177): test for download when functionality is added.
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareView subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: subject,
        ),
      );
}
