import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:rive/rive.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackgroundAnimation', () {
    late RiveFile riveFile;

    setUp(() async {
      riveFile = await RiveFile.asset(Assets.animations.dashMobile.path);
    });

    testWidgets('contains RiveAnimation', (tester) async {
      await tester.pumpApp(BackgroundAnimation(riveFile: riveFile));

      expect(find.byType(RiveAnimation), findsOneWidget);
    });
  });
}
