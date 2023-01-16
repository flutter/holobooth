// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('AppCircularProgressIndicator', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(AppCircularProgressIndicator());
      expect(find.byType(AppCircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders with default colors', (tester) async {
      await tester.pumpWidget(AppCircularProgressIndicator());
      final widget = tester.widget<AppCircularProgressIndicator>(
        find.byType(AppCircularProgressIndicator),
      );
      expect(widget.color, HoloBoothColors.orange);
      expect(widget.backgroundColor, HoloBoothColors.white);
    });

    testWidgets('renders with provided colors', (tester) async {
      const color = HoloBoothColors.black;
      const backgroundColor = HoloBoothColors.blue;
      await tester.pumpWidget(
        AppCircularProgressIndicator(
          color: color,
          backgroundColor: backgroundColor,
        ),
      );
      final widget = tester.widget<AppCircularProgressIndicator>(
        find.byType(AppCircularProgressIndicator),
      );
      expect(widget.color, color);
      expect(widget.backgroundColor, backgroundColor);
    });
  });
}
