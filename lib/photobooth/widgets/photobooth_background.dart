import 'package:flutter/material.dart';
import 'package:io_photobooth/gen/assets.gen.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Assets.backgrounds.photoboothBackground.image(
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
        ),
        Positioned(
          left: 50,
          bottom: size.height * 0.2,
          child: Assets.backgrounds.redBox.image(
            height: 150,
          ),
        ),
        Positioned(
          right: -50,
          top: size.height * 0.1,
          child: Assets.backgrounds.blueCircle.image(
            height: 150,
          ),
        ),
        Positioned(
          right: 50,
          bottom: size.height * 0.1,
          child: Assets.backgrounds.yellowPlus.image(
            height: 150,
          ),
        ),
      ],
    );
  }
}
