import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture_viewer/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareButton', () {
    test('can be instantiated', () {
      expect(ShareButton(), isA<ShareButton>());
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = ShareButton();
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });

    group('onPressed', () {
      testWidgets('opens ShareDialog when on landscape', (tester) async {
        tester.setLandscapeDisplaySize();

        final subject = ShareButton();
        await tester.pumpSubject(subject);
        await tester.tap(find.byWidget(subject));
        await tester.pumpAndSettle();

        expect(find.byType(ShareDialog), findsOneWidget);
      });

      testWidgets('opens ShareBottomSheet when on portrait', (tester) async {
        tester.setPortraitDisplaySize();

        final subject = ShareButton();
        await tester.pumpSubject(subject);
        await tester.tap(find.byWidget(subject));
        await tester.pumpAndSettle();

        expect(find.byType(ShareBottomSheet), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareButton subject) {
    return pumpApp(subject);
  }
}
