import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final enablePlatformTests =
      !Platform.environment.containsKey('GITHUB_ACTIONS');
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: PhotoboothTheme.standard,
      platformGoldensConfig:
          AlchemistConfig.current().platformGoldensConfig.copyWith(
                enabled: enablePlatformTests,
                renderShadows: enablePlatformTests,
              ),
    ),
    run: testMain,
  );
}
