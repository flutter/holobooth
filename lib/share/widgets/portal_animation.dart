import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
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

class PortalAnimation extends StatefulWidget {
  const PortalAnimation({
    super.key,
    required this.mode,
    required this.imageBytes,
    required this.onComplete,
  });

  final PortalMode mode;

  final Uint8List imageBytes;

  final VoidCallback onComplete;

  @override
  State<PortalAnimation> createState() => _PortalAnimationState();
}

class _PortalAnimationState extends State<PortalAnimation> {
  late final _game = PortalGame(
    mode: widget.mode,
    imageBytes: widget.imageBytes,
    onComplete: widget.onComplete,
  );

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}

@visibleForTesting
class PortalGame extends FlameGame {
  PortalGame({
    required this.mode,
    required this.imageBytes,
    required this.onComplete,
  });

  final PortalMode mode;

  final Uint8List imageBytes;

  final VoidCallback onComplete;

  @override
  Future<void> onLoad() async {
    final data = mode.data;
    images.prefix = '';

    final image = await decodeImageFromList(imageBytes);

    final playIconImage = Assets.icons.playIcon.image();
    final thumb = Sprite(image);
    final playSprite = Sprite(playIconImage);

    final animation = await loadSpriteAnimation(
      data.texturePath,
      SpriteAnimationData.sequenced(
        amount: 90,
        amountPerRow: 10,
        textureSize: data.textureSize,
        stepTime: .05,
        loop: false,
      ),
    );

    final frameComponent = SpriteAnimationComponent(
      animation: animation,
      size: data.textureSize,
      position: -data.textureSize / 2,
    );

    add(frameComponent);

    animation.onComplete = () {
      onComplete();
      frameComponent.add(
        ThumbComponent(
          sprite: thumb,
          data: data,
        ),
      );
    };

    final scaleX = size.x / data.textureSize.x;
    final scaleY = size.x / data.textureSize.y;

    camera
      ..zoom = math.min(scaleX, scaleY)
      ..followVector2(Vector2.zero());
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

@visibleForTesting
class ThumbComponent extends PositionComponent with HasPaint {
  ThumbComponent({
    required this.sprite,
    required this.data,
  });

  final Sprite sprite;
  final PortalModeData data;
  late final Rect clipRect;
  late final Vector2 renderSize;

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

    final rateX = data.thumbSize.x / size.x;
    final rateY = data.thumbSize.y / size.y;

    final rate = math.max(rateX, rateY);

    renderSize = size * rate;
  }

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..clipRect(clipRect);

    sprite.render(
      canvas,
      size: renderSize,
      position: data.thumbSize / 2,
      anchor: Anchor.center,
      overridePaint: paint,
    );

    canvas.restore();
  }
}
