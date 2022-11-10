import 'dart:async';

import 'package:flutter/material.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimatedPhotoboothPhoto extends StatefulWidget {
  const AnimatedPhotoboothPhoto({
    super.key,
    required this.image,
  });

  final PhotoboothCameraImage? image;

  @override
  State<AnimatedPhotoboothPhoto> createState() =>
      _AnimatedPhotoboothPhotoState();
}

class _AnimatedPhotoboothPhotoState extends State<AnimatedPhotoboothPhoto> {
  late final Timer timer;
  var _isPhotoVisible = false;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _isPhotoVisible = true;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPhotoboothPhotoLandscape(
      image: widget.image,
      isPhotoVisible: _isPhotoVisible,
    );
  }
}

@visibleForTesting
class AnimatedPhotoboothPhotoLandscape extends StatelessWidget {
  const AnimatedPhotoboothPhotoLandscape({
    super.key,
    required this.image,
    required this.isPhotoVisible,
  });

  final PhotoboothCameraImage? image;
  final bool isPhotoVisible;

  static const sprite = AnimatedSprite(
    mode: AnimationMode.oneTime,
    sprites: Sprites(
      asset: 'photo_frame_spritesheet_landscape.jpg',
      size: Size(1308, 1038),
      frames: 19,
      stepTime: 2 / 19,
    ),
    showLoadingIndicator: false,
  );
  static const aspectRatio = PhotoboothAspectRatio.landscape;
  static const left = 129.0;
  static const top = 88.0;
  static const right = 118.0;
  static const bottom = 154.0;

  @override
  Widget build(BuildContext context) {
    final smallPhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.33,
    );
    final mediumPhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.37,
    );
    final largePhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.5,
    );
    final xLargePhoto = _AnimatedPhotoboothPhoto(
      aspectRatio: aspectRatio,
      image: image,
      isPhotoVisible: isPhotoVisible,
      sprite: sprite,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      scale: 0.52,
    );

    return ResponsiveLayoutBuilder(
      small: (context, _) => smallPhoto,
      medium: (context, _) => mediumPhoto,
      large: (context, _) => largePhoto,
      xLarge: (context, _) => xLargePhoto,
    );
  }
}

class _AnimatedPhotoboothPhoto extends StatelessWidget {
  const _AnimatedPhotoboothPhoto({
    required this.sprite,
    required this.isPhotoVisible,
    required this.aspectRatio,
    required this.image,
    this.top = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.scale = 1.0,
  });

  final AnimatedSprite sprite;
  final bool isPhotoVisible;
  final double aspectRatio;
  final PhotoboothCameraImage? image;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double scale;

  @override
  Widget build(BuildContext context) {
    const reductionFactor = 0.19;
    // ignore: no_leading_underscores_for_local_identifiers
    final _image = image;
    return SizedBox(
      height: sprite.sprites.size.height * scale,
      width: sprite.sprites.size.width * scale,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(sprite.sprites.size),
              child: sprite,
            ),
          ),
          if (_image != null)
            Positioned(
              top: top * scale,
              left: left * scale,
              right: right * scale,
              bottom: bottom * scale,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: isPhotoVisible ? 1 : 0,
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: PreviewImage(
                    data: _image.data,
                    height: _image.constraint.height * reductionFactor,
                    width: _image.constraint.width * reductionFactor,
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
