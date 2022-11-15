import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

// class FakePhotoboothEvent extends Fake implements PhotoBoothEvent {}

// class FakePhotoboothState extends Fake implements PhotoBoothState {}

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

    testWidgets('renders GradientBackground', (tester) async {
      await tester.pumpApp(SharePage(images: images));
      expect(find.byType(GradientBackground), findsOneWidget);
    });

    // testWidgets('renders WhiteFooter', (tester) async {
    //   await tester.pumpApp(SharePage(images: images));
    //   expect(find.byType(WhiteFooter), findsOneWidget);
    // });
  });
}
