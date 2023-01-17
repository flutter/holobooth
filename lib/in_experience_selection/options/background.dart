import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';

enum Background {
  bg0,
  bg1,
  bg2,
  bg3,
  bg4,
  bg5,
  bg6,
  bg7,
  bg8;

  ImageProvider thumbnailImageProvider() {
    switch (this) {
      case Background.bg0:
        return Assets.backgrounds.bgThumbnail00.provider();
      case Background.bg1:
        return Assets.backgrounds.bgThumbnail01.provider();
      case Background.bg2:
        return Assets.backgrounds.bgThumbnail02.provider();
      case Background.bg3:
        return Assets.backgrounds.bgThumbnail03.provider();
      case Background.bg4:
        return Assets.backgrounds.bgThumbnail04.provider();
      case Background.bg5:
        return Assets.backgrounds.bgThumbnail05.provider();
      case Background.bg6:
        return Assets.backgrounds.bgThumbnail06.provider();
      case Background.bg7:
        return Assets.backgrounds.bgThumbnail07.provider();
      case Background.bg8:
        return Assets.backgrounds.bgThumbnail08.provider();
    }
  }
}
