import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class _MockPlatformHelper extends Mock implements PlatformHelper {}

class FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  group('ShareButton', () {
    late PlatformHelper platformHelper;

    setUp(() {
      platformHelper = _MockPlatformHelper();
    });

    test('can be instantiated', () {
      final image = FakePhotoboothCameraImage();
      expect(ShareButton(image: image), isA<ShareButton>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final image = FakePhotoboothCameraImage();
        final subject = ShareButton(image: image);
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });

    group('onPressed', () {
      final image = FakePhotoboothCameraImage();
      testWidgets(
        'opens ShareDialog when on desktop and landscape',
        (tester) async {
          when(() => platformHelper.isMobile).thenReturn(false);
          tester.setLandscapeDisplaySize();

          final subject = ShareButton(
            image: image,
            platformHelper: platformHelper,
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

      testWidgets(
        'opens ShareBottomSheet when on desktop and portrait',
        (tester) async {
          when(() => platformHelper.isMobile).thenReturn(false);
          tester.setPortraitDisplaySize();

          final subject = ShareButton(
            image: image,
            platformHelper: platformHelper,
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: ShareBloc(),
              child: subject,
            ),
          );
          await tester.tap(find.byWidget(subject));
          await tester.pumpAndSettle();

          expect(find.byType(ShareBottomSheet), findsOneWidget);
        },
      );

      testWidgets(
        'opens ShareBottomSheet when on mobile and landscape',
        (tester) async {
          when(() => platformHelper.isMobile).thenReturn(true);
          tester.setLandscapeDisplaySize();

          final subject = ShareButton(
            image: image,
            platformHelper: platformHelper,
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: ShareBloc(),
              child: subject,
            ),
          );
          await tester.tap(find.byWidget(subject));
          await tester.pumpAndSettle();

          expect(find.byType(ShareBottomSheet), findsOneWidget);
        },
      );

      testWidgets(
        'opens ShareBottomSheet when on mobile and portrait',
        (tester) async {
          when(() => platformHelper.isMobile).thenReturn(true);
          tester.setPortraitDisplaySize();

          final subject = ShareButton(
            image: image,
            platformHelper: platformHelper,
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: ShareBloc(),
              child: subject,
            ),
          );
          await tester.tap(find.byWidget(subject));
          await tester.pumpAndSettle();

          expect(find.byType(ShareBottomSheet), findsOneWidget);
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
