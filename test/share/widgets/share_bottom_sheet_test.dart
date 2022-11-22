import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';

class FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  group('ShareBottomSheet', () {
    final image = FakePhotoboothCameraImage();
    test('can be instantiated', () {
      expect(
        ShareBottomSheet(
          image: image,
        ),
        isA<ShareBottomSheet>(),
      );
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = ShareBottomSheet(
          image: image,
        );
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareBottomSheet subject) {
    return pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: subject,
      ),
    );
  }
}
