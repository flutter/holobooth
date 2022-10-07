import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('MultipleCaptureViewerPage', () {
    testWidgets('renders n PreviewImage', (tester) async {
      const numberOfImages = 3;
      await tester.pumpSubject(
        MultipleCaptureViewerPage(
          images: List.generate(
            numberOfImages,
            (index) => PhotoboothCameraImage(
              constraint: PhotoConstraint(height: 100, width: 100),
              data: '',
            ),
          ),
        ),
      );
      expect(find.byType(PreviewImage), findsNWidgets(numberOfImages));
    });

    testWidgets(
      'navigates to MultipleCapturePage if click on retake photo button',
      (tester) async {
        await tester.pumpSubject(MultipleCaptureViewerPage(images: const []));
        final takePhotoAgainButtonFinder =
            find.byKey(TakePhotoAgainButton.buttonKey);
        tester.widget<AppTooltipButton>(takePhotoAgainButtonFinder).onPressed();
        await tester.pumpAndSettle();
        expect(find.byType(MultipleCapturePage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    MultipleCaptureViewerPage subject,
  ) =>
      pumpApp(subject);
}
