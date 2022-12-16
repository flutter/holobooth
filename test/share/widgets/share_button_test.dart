import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  group('ShareButton', () {
    test('can be instantiated', () {
      final image = _FakePhotoboothCameraImage();
      expect(ShareButton(image: image), isA<ShareButton>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final image = _FakePhotoboothCameraImage();
        final subject = ShareButton(image: image);
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });

    group('onPressed', () {
      final image = _FakePhotoboothCameraImage();
      testWidgets(
        'opens ShareDialog',
        (tester) async {
          tester.setLandscapeDisplaySize();

          final subject = ShareButton(
            image: image,
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: ShareBloc(),
              child: subject,
            ),
          );
          await tester.tap(find.byWidget(subject));
          await tester.pumpAndSettle();

          expect(find.byType(ShareDialog), findsOneWidget);
        },
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareButton subject) {
    return pumpApp(
      Scaffold(
        body: subject,
      ),
    );
  }
}
