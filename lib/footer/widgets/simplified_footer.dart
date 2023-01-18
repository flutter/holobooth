import 'package:flutter/material.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class SimplifiedFooter extends StatelessWidget {
  const SimplifiedFooter({super.key});

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
                TensorflowIconLink()
              ],
            ),
          );
        },
        large: (_, __) {
          return Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 48, bottom: 24, right: 24),
            child: Row(
              children: const [
                FlutterIconLink(),
                SizedBox(width: _separationSize),
                FirebaseIconLink(),
                SizedBox(width: _separationSize),
                TensorflowIconLink(),
                Spacer(),
                MuteButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
