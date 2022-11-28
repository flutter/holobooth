import 'package:face_geometry/face_geometry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class _MockBoundingBox extends Mock implements BoundingBox {}

void main() {
  group('FaceDistance', () {
    late BoundingBox boundingBox;
    late Size imageSize;

    setUp(() {
      imageSize = Size(10, 10);
      boundingBox = _MockBoundingBox();
      when(() => boundingBox.width).thenReturn(imageSize.width / 2);
      when(() => boundingBox.height).thenReturn(imageSize.height / 2);
    });

    group('factory constructor', () {
      test('returns normally', () {
        expect(
          () => FaceDistance(
            boundingBox: boundingBox,
            imageSize: imageSize,
          ),
          returnsNormally,
        );
      });

      group('throws AssertionError when', () {
        Matcher throwsAssertionErrorWithMessage(String message) {
          final typeMatcher = isA<AssertionError>()
              .having((e) => e.message, 'message', message);
          return throwsA(typeMatcher);
        }

        test(
          'image width is smaller or equal than zero',
          () {
            const assertionMessage =
                'The imageSize width must be greater than 0.';
            imageSize = Size(0, 10);

            expect(
              () => FaceDistance(
                boundingBox: boundingBox,
                imageSize: imageSize,
              ),
              throwsAssertionErrorWithMessage(assertionMessage),
            );
          },
        );

        test(
          'image height is smaller or equal than zero',
          () {
            const assertionMessage =
                'The imageSize height must be greater than 0.';
            imageSize = Size(10, 0);

            expect(
              () => FaceDistance(
                boundingBox: boundingBox,
                imageSize: imageSize,
              ),
              throwsAssertionErrorWithMessage(assertionMessage),
            );
          },
        );

        test(
          'boundingBox width is greater than image width',
          () {
            const assertionMessage =
                'The boundingBoxSize width must be less than the imageSize '
                'width.';
            when(() => boundingBox.width).thenReturn(imageSize.width + 1);

            expect(
              () => FaceDistance(
                boundingBox: boundingBox,
                imageSize: imageSize,
              ),
              throwsAssertionErrorWithMessage(assertionMessage),
            );
          },
        );

        test(
          'boundingBox height is greater than image height',
          () {
            const assertionMessage =
                'The boundingBoxSize height must be less than the imageSize '
                'height.';
            when(() => boundingBox.height).thenReturn(imageSize.height + 1);

            expect(
              () => FaceDistance(
                boundingBox: boundingBox,
                imageSize: imageSize,
              ),
              throwsAssertionErrorWithMessage(assertionMessage),
            );
          },
        );
      });
    });

    group('value', () {});
  });
}
