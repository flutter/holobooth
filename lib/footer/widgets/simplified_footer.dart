import 'package:flutter/material.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/widgets/widgets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class SimplifiedFooter extends StatelessWidget {
  SimplifiedFooter({super.key, PlatformHelper? platformHelper})
      : _platformHelper = platformHelper ?? PlatformHelper();

  final PlatformHelper _platformHelper;

  static const _separationSize = 22.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ResponsiveLayoutBuilder(
        small: (_, __) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FlutterIconLink(),
                SizedBox(width: _separationSize),
                FirebaseIconLink(),
                SizedBox(width: _separationSize),
                TensorflowIconLink(),
                SizedBox(width: _separationSize),
                MediapipeIconLink(),
              ],
            ),
          );
        },
        large: (_, __) {
          return Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 48, bottom: 24, right: 24),
            child: Row(
              children: [
                const FlutterIconLink(),
                const SizedBox(width: _separationSize),
                const FirebaseIconLink(),
                const SizedBox(width: _separationSize),
                const TensorflowIconLink(),
                const SizedBox(width: _separationSize),
                const MediapipeIconLink(),
                if (!_platformHelper.isMobile) ...[
                  const Spacer(),
                  const MuteButton(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
