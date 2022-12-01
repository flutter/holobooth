import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.gen.dart';

enum Background { space, forest }

extension BackgroundX on Background {
  ImageProvider toImageProvider() {
    switch (this) {
      case Background.space:
        return Assets.backgrounds.space.provider();
      case Background.forest:
        return Assets.backgrounds.forest.provider();
    }
  }

  double toDouble() {
    switch (this) {
      case Background.space:
        return 1;
      case Background.forest:
        return 2;
    }
  }
}
