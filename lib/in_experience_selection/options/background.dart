import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Background { space, beach, underwater }

extension BackgroundX on Background {
  double toDouble() {
    switch (this) {
      case Background.space:
        return 1;
      case Background.beach:
        return 2;
      case Background.underwater:
        return 3;
    }
  }

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
