import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

class _MockCameraException extends Mock implements CameraException {}

extension on WidgetTester {
  Future<void> pumpSubject(PhotoboothError subject) {
    return pumpWidget(
      Localizations(
        locale: const Locale('en'),
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: MediaQuery.fromWindow(
          child: Theme(
            data: ThemeData(),
            child: Builder(builder: (context) => subject),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('PhotoboothError', () {
    late _MockCameraException cameraException;

    setUp(() {
      cameraException = _MockCameraException();
    });

    test('can be instantiated', () {
      expect(
        PhotoboothError(error: cameraException),
        isA<PhotoboothError>(),
      );
    });

    group('renders', () {
      testWidgets(
        'cameraAccessDeniedKey when error code is CameraAccessDenied',
        (tester) async {
          when(() => cameraException.code).thenReturn('CameraAccessDenied');
          final subject = PhotoboothError(error: cameraException);
          await tester.pumpSubject(subject);

          expect(
            find.byKey(PhotoboothError.cameraAccessDeniedKey),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'cameraNotFoundKey when error code is cameraNotFound',
        (tester) async {
          when(() => cameraException.code).thenReturn('cameraNotFound');
          final subject = PhotoboothError(error: cameraException);
          await tester.pumpSubject(subject);

          expect(
            find.byKey(PhotoboothError.cameraNotFoundKey),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'cameraNotSupportedKey when error code is cameraNotSupported',
        (tester) async {
          when(() => cameraException.code).thenReturn('cameraNotSupported');
          final subject = PhotoboothError(error: cameraException);
          await tester.pumpSubject(subject);

          expect(
            find.byKey(PhotoboothError.cameraNotSupportedKey),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'unknownErrorKey when error code is unknown',
        (tester) async {
          when(() => cameraException.code).thenReturn('');
          final subject = PhotoboothError(error: cameraException);
          await tester.pumpSubject(subject);

          expect(
            find.byKey(PhotoboothError.unknownErrorKey),
            findsOneWidget,
          );
        },
      );
    });
  });
}
