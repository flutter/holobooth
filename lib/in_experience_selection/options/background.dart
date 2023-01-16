import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';

enum Background {
  bg00,
  bg01,
  bg02,
  bg03,
  bg04,
  bg05,
  bg06,
  bg07,
  bg08;

  ImageProvider toImageProvider() {
    switch (this) {
      case Background.bg00:
        return Assets.backgrounds.bg00.provider();
      case Background.bg01:
        return Assets.backgrounds.bg01.provider();
      case Background.bg02:
        return Assets.backgrounds.bg02.provider();
      case Background.bg03:
        return Assets.backgrounds.bg03.provider();
      case Background.bg04:
        return Assets.backgrounds.bg04.provider();
      case Background.bg05:
        return Assets.backgrounds.bg05.provider();
      case Background.bg06:
        return Assets.backgrounds.bg06.provider();
      case Background.bg07:
        return Assets.backgrounds.bg07.provider();
      case Background.bg08:
        return Assets.backgrounds.bg08.provider();
    }
  }
}
