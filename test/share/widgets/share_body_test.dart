import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

class _FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  group('ShareBody', () {
    final images = [
      _FakePhotoboothCameraImage(),
      _FakePhotoboothCameraImage(),
      _FakePhotoboothCameraImage()
    ];

    testWidgets('displays a AnimatedPhotoboothPhoto in small layout',
        (tester) async {
      tester.setSmallDisplaySize();
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(find.byType(AnimatedPhotoboothPhoto), findsOneWidget);
    });

    testWidgets('displays a AnimatedPhotoboothPhoto in large layout',
        (tester) async {
      tester.setLargeDisplaySize();
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
      expect(
        find.byType(DownloadButton),
        findsOneWidget,
      );
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: ShareBody(
            images: images,
          ),
        ),
      );
      expect(
        find.byType(RetakeButton),
        findsOneWidget,
      );
    });

    testWidgets(
      'RetakeButton navigates to photobooth when pressed',
      (tester) async {
        await tester.pumpApp(
          SingleChildScrollView(
            child: ShareBody(
              images: images,
            ),
          ),
        );

        final finder = find.byType(RetakeButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump(kThemeAnimationDuration);
        await tester.pump(kThemeAnimationDuration);
        expect(find.byType(PhotoBoothPage), findsOneWidget);
      },
    );
  });
}
