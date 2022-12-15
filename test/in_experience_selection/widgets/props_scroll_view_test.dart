import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PropsScrollView', () {
    testWidgets('renders ListView in small layout', (tester) async {
      tester.setSmallDisplaySize();
      await tester.pumpApp(
        PropsScrollView(
          itemBuilder: (context, index) => SizedBox(),
          itemCount: 2,
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders GridView in large layout', (tester) async {
      tester.setLandscapeDisplaySize();
      await tester.pumpApp(
        PropsScrollView(
          itemBuilder: (context, index) => SizedBox(),
          itemCount: 2,
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
