import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCameraException extends Mock implements CameraException {}

void main() {
  group('CameraErrorView', () {
    late _MockCameraException cameraException;

    setUp(() {
      cameraException = _MockCameraException();
    });

    testWidgets(
      'CameraAccessDeniedErrorView when error code is CameraAccessDenied',
      (tester) async {
        when(() => cameraException.code).thenReturn('CameraAccessDenied');
        final subject = CameraErrorView(error: cameraException);
        await tester.pumpSubject(subject);

        expect(
          find.byType(CameraAccessDeniedErrorView),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'CameraNotFoundErrorView when error code is unknown',
      (tester) async {
        when(() => cameraException.code).thenReturn('');
        final subject = CameraErrorView(error: cameraException);
        await tester.pumpSubject(subject);

        expect(
          find.byType(CameraNotFoundErrorView),
          findsOneWidget,
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(CameraErrorView subject) => pumpApp(subject);
}
