import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Clothes {
  none(0),
  shirt01(1),
  shirt02(2),
  shirt03(3),
  shirt04(4),
  shirt05(5),
  shirt06(6),
  shirt07(7),
  shirt08(8),
  shirt09(9);

  const Clothes(this.riveIndex);
  final double riveIndex;

  ImageProvider toImageProvider() {
    switch (this) {
      case Clothes.none:
        return Assets.props.noneProps.provider();
      case Clothes.shirt01:
        return Assets.props.shirt01.provider();
      case Clothes.shirt02:
        return Assets.props.shirt02.provider();
      case Clothes.shirt03:
        return Assets.props.shirt03.provider();
      case Clothes.shirt04:
        return Assets.props.shirt04.provider();
      case Clothes.shirt05:
        return Assets.props.shirt05.provider();
      case Clothes.shirt06:
        return Assets.props.shirt06.provider();
      case Clothes.shirt07:
        return Assets.props.shirt07.provider();
      case Clothes.shirt08:
        return Assets.props.shirt08.provider();
      case Clothes.shirt09:
        return Assets.props.shirt09.provider();
    }
  }
}
