import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';

enum PortalMode {
  portrait,
  landscape;

  PortalModeData get data {
    switch (this) {
      case PortalMode.portrait:
        return PortalModeData(
          texturePath: Assets.animations.mobilePortalSpritesheet.path,
          textureSize: Vector2(650, 850),
          thumbSize: Vector2(322, 378),
          thumbOffset: Vector2(168, 104),
        );
      case PortalMode.landscape:
        return PortalModeData(
          texturePath: Assets.animations.desktopPortalSpritesheet.path,
          textureSize: Vector2(710, 750),
          thumbSize: Vector2(498, 280),
          thumbOffset: Vector2(100, 96),
        );
    }
  }
}

class PortalModeData {
  PortalModeData({
    required this.texturePath,
    required this.textureSize,
    required this.thumbSize,
    required this.thumbOffset,
  });

  final String texturePath;
  final Vector2 textureSize;
  final Vector2 thumbSize;
  final Vector2 thumbOffset;
}

class PortalAnimation extends StatelessWidget {
  const PortalAnimation({
    super.key,
    required this.mode,
    //required this.image,
  });

  final PortalMode mode;

  //final Image image;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      //game: _PortalGame(image),
      game: _PortalGame(mode: mode),
    );
  }
}

class _PortalGame extends FlameGame {
  //_PortalGame(this.image);
  _PortalGame({
    required this.mode,
  });

  final PortalMode mode;

  //final Image image;

  @override
  Future<void> onLoad() async {
    final data = mode.data;
    images.prefix = '';

    // TODO receive thumb
    final thumb = await loadSprite(Assets.backgrounds.bgThumbnail06.path);

    final animation = await loadSpriteAnimation(
      data.texturePath,
      SpriteAnimationData.sequenced(
        amount: 90,
        amountPerRow: 10,
        textureSize: data.textureSize,
        stepTime: .01,
        loop: false,
      ),
    );

    // 100x96
    // 496x278

    final frameComponent = SpriteAnimationComponent(
      animation: animation,
      size: data.textureSize,
    );

    add(frameComponent);

    animation.onComplete = () {
      frameComponent.add(
        _ThumbComponent(
          sprite: thumb,
          data: data,
        ),
      );
    };

    camera.zoom = .5;
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

class _ThumbComponent extends PositionComponent with HasPaint {
  _ThumbComponent({
    required this.sprite,
    required this.data,
  });

  final Sprite sprite;
  final PortalModeData data;
  late final Rect clipRect;

  @override
  Future<void> onLoad() async {
    size = Vector2(
      sprite.image.width.toDouble(),
      sprite.image.height.toDouble(),
    );

    position = data.thumbOffset;

    paint.color = Colors.white.withOpacity(0);
    add(OpacityEffect.fadeIn(LinearEffectController(.5)));

    clipRect = Rect.fromLTWH(
      0,
      0,
      data.thumbSize.x,
      data.thumbSize.y,
    );
  }

  @override
  void render(Canvas canvas) {
    final width = data.thumbSize.x > data.thumbSize.y;
    final spriteValue = width ? size.x : size.y;
    final frameValue = width ? data.thumbSize.x : data.thumbSize.y;

    final rate = frameValue / spriteValue;

    final renderSize = size * rate;

    canvas
      ..save()
      ..clipRect(clipRect);

    sprite.render(
      canvas,
      size: renderSize,
      position: renderSize / 2,
      anchor: Anchor.center,
      overridePaint: paint,
    );

    canvas.restore();
  }
}
