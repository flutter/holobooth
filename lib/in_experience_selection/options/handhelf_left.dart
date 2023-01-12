import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

enum HandheldlLeft {
  none(0),
  handheld01(1),
  handheld02(2),
  handheld03(3),
  handheld04(4),
  handheld05(5),
  handheld06(6),
  handheld07(7),
  handheld08(8),
  handheld09(9);

  const HandheldlLeft(this.riveIndex);
  final double riveIndex;

  ImageProvider? toImageProvider() {
    switch (this) {
      case HandheldlLeft.none:
        return null;
      case HandheldlLeft.handheld01:
        return Assets.props.handheld01.provider();
      case HandheldlLeft.handheld02:
        return Assets.props.handheld02.provider();
      case HandheldlLeft.handheld03:
        return Assets.props.handheld03.provider();
      case HandheldlLeft.handheld04:
        return Assets.props.handheld04.provider();
      case HandheldlLeft.handheld05:
        return Assets.props.handheld05.provider();
      case HandheldlLeft.handheld06:
        return Assets.props.handheld06.provider();
      case HandheldlLeft.handheld07:
        return Assets.props.handheld07.provider();
      case HandheldlLeft.handheld08:
        return Assets.props.handheld08.provider();
      case HandheldlLeft.handheld09:
        return Assets.props.handheld09.provider();
    }
  }
}
