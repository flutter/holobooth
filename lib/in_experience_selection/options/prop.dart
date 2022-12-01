import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';

enum Prop {
  helmet,
}

extension PropX on Prop {
  ImageProvider toImageProvider() {
    switch (this) {
      case Prop.helmet:
        return Assets.props.prop1.provider();
    }
  }
}
