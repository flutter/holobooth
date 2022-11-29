import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';

import '../../helpers/helpers.dart';

class FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  group('ShareDialog', () {
    final image = FakePhotoboothCameraImage();
    test('can be instantiated', () {
      expect(
        ShareDialog(
          image: image,
        ),
        isA<ShareDialog>(),
      );
    });

    testWidgets('tapping on close will dismiss the popup', (tester) async {
      await tester.pumpApp(Material(child: ShareDialog(image: image)));
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsNothing);
    });

    group('renders', () {
      final image = FakePhotoboothCameraImage();
      testWidgets('successfully', (tester) async {
        final subject = ShareDialog(
          image: image,
        );
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialog subject) {
    return pumpApp(
      Material(
        child: subject,
      ),
    );
  }
}
