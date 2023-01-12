import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Glasses {
  none(0),
  glasses01(1),
  glasses02(2),
  glasses03(3),
  glasses04(4),
  glasses05(5),
  glasses06(6),
  glasses07(7),
  glasses08(8),
  glasses09(9);

  const Glasses(this.riveIndex);
  final double riveIndex;

  ImageProvider? toImageProvider() {
    switch (this) {
      case Glasses.none:
        return null;
      case Glasses.glasses01:
        return Assets.props.glasses01.provider();
      case Glasses.glasses02:
        return Assets.props.glasses02.provider();
      case Glasses.glasses03:
        return Assets.props.glasses03.provider();
      case Glasses.glasses04:
        return Assets.props.glasses04.provider();
      case Glasses.glasses05:
        return Assets.props.glasses05.provider();
      case Glasses.glasses06:
        return Assets.props.glasses06.provider();
      case Glasses.glasses07:
        return Assets.props.glasses07.provider();
      case Glasses.glasses08:
        return Assets.props.glasses08.provider();
      case Glasses.glasses09:
        return Assets.props.glasses09.provider();
    }
  }
}
