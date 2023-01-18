import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';

enum Hats {
  none(0),
  hat01(1),
  hat02(2),
  hat03(3),
  hat04(4),
  hat05(5),
  hat06(6),
  hat07(7),
  hat08(8),
  hat09(9);

  const Hats(this.riveIndex);
  final double riveIndex;

  ImageProvider toImageProvider() {
    switch (this) {
      case Hats.none:
        return Assets.props.noneProps.provider();
      case Hats.hat01:
        return Assets.props.hat01.provider();
      case Hats.hat02:
        return Assets.props.hat02.provider();
      case Hats.hat03:
        return Assets.props.hat03.provider();
      case Hats.hat04:
        return Assets.props.hat04.provider();
      case Hats.hat05:
        return Assets.props.hat05.provider();
      case Hats.hat06:
        return Assets.props.hat06.provider();
      case Hats.hat07:
        return Assets.props.hat07.provider();
      case Hats.hat08:
        return Assets.props.hat08.provider();
      case Hats.hat09:
        return Assets.props.hat09.provider();
    }
  }
}
