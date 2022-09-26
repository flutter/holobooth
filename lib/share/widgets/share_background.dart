import 'package:flutter/material.dart';
import 'package:io_photobooth/gen/assets.gen.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBackground extends StatelessWidget {
  const ShareBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Assets.backgrounds.photoboothBackground.image(
            repeat: ImageRepeat.repeat,
            filterQuality: FilterQuality.high,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhotoboothColors.transparent,
                PhotoboothColors.black54,
              ],
            ),
          ),
        ),
        ResponsiveLayoutBuilder(
          large: (_, __) => Align(
            alignment: Alignment.bottomLeft,
            child: Assets.backgrounds.yellowBar.image(
              filterQuality: FilterQuality.high,
            ),
          ),
          small: (_, __) => const SizedBox(),
        ),
        ResponsiveLayoutBuilder(
          large: (_, __) => Align(
            alignment: Alignment.topRight,
            child: Assets.backgrounds.circleObject.image(
              filterQuality: FilterQuality.high,
            ),
          ),
          small: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
