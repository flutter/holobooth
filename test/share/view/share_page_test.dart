import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

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
      await tester.pumpAndSettle();
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
