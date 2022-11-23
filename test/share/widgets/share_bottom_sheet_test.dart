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

    testWidgets('displays subheading', (tester) async {
      await tester.pumpApp(
        Scaffold(body: ShareBottomSheet(image: image)),
      );
      expect(find.byKey(Key('shareBottomSheet_subheading')), findsOneWidget);
    });

    testWidgets('displays a TwitterButton', (tester) async {
      await tester.pumpApp(
        Scaffold(body: ShareBottomSheet(image: image)),
      );
      expect(find.byType(TwitterButton), findsOneWidget);
    });

    testWidgets('displays a FacebookButton', (tester) async {
      await tester.pumpApp(
        Scaffold(body: ShareBottomSheet(image: image)),
      );
      expect(find.byType(FacebookButton), findsOneWidget);
    });

    testWidgets('taps on close will dismiss the popup', (tester) async {
      await tester.pumpApp(
        Scaffold(body: ShareBottomSheet(image: image)),
      );
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareBottomSheet), findsNothing);
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
    return pumpApp(
      Material(
        child: subject,
      ),
    );
  }
}
