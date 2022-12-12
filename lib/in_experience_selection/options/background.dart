import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Background {
  space(
    1,
  ),
  beach(2),
  underwater(3);

  const Background(this.riveIndex);
  final double riveIndex;

  ImageProvider toImageProvider() {
    switch (this) {
      case Background.space:
        return Assets.backgrounds.space.provider();
      case Background.beach:
        return Assets.backgrounds.beach.provider();

      case Background.underwater:
        return Assets.backgrounds.underwater.provider();
    }
  }
}
