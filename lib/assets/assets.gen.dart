/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/camera.mp3
  String get camera => 'assets/audio/camera.mp3';
}

class $AssetsBackgroundsGen {
  const $AssetsBackgroundsGen();

  /// File path: assets/backgrounds/blue_circle.png
  AssetGenImage get blueCircle =>
      const AssetGenImage('assets/backgrounds/blue_circle.png');

  /// File path: assets/backgrounds/landing_background.png
  AssetGenImage get landingBackground =>
      const AssetGenImage('assets/backgrounds/landing_background.png');

  /// File path: assets/backgrounds/photobooth_background.jpg
  AssetGenImage get photoboothBackground =>
      const AssetGenImage('assets/backgrounds/photobooth_background.jpg');

  /// File path: assets/backgrounds/red_box.png
  AssetGenImage get redBox =>
      const AssetGenImage('assets/backgrounds/red_box.png');

  /// File path: assets/backgrounds/yellow_plus.png
  AssetGenImage get yellowPlus =>
      const AssetGenImage('assets/backgrounds/yellow_plus.png');
}

class $AssetsCharactersGen {
  const $AssetsCharactersGen();

  /// File path: assets/characters/dash.png
  AssetGenImage get dash => const AssetGenImage('assets/characters/dash.png');

  /// File path: assets/characters/sparky.png
  AssetGenImage get sparky =>
      const AssetGenImage('assets/characters/sparky.png');
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/camera_button_icon.png
  AssetGenImage get cameraButtonIcon =>
      const AssetGenImage('assets/icons/camera_button_icon.png');

  /// File path: assets/icons/retake_button_icon.png
  AssetGenImage get retakeButtonIcon =>
      const AssetGenImage('assets/icons/retake_button_icon.png');
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsBackgroundsGen backgrounds = $AssetsBackgroundsGen();
  static const $AssetsCharactersGen characters = $AssetsCharactersGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class RiveGenImage {
  const RiveGenImage(this._assetName);

  final String _assetName;

  RiveAnimation rive({
    String? artboard,
    List<String> animations = const [],
    List<String> stateMachines = const [],
    BoxFit? fit,
    Alignment? alignment,
    Widget? placeHolder,
    bool antialiasing = true,
    List<RiveAnimationController> controllers = const [],
    OnInitCallback? onInit,
  }) {
    return RiveAnimation.asset(
      _assetName,
      artboard: artboard,
      animations: animations,
      stateMachines: stateMachines,
      fit: fit,
      alignment: alignment,
      placeHolder: placeHolder,
      antialiasing: antialiasing,
      controllers: controllers,
      onInit: onInit,
    );
  }

  String get path => _assetName;
}
