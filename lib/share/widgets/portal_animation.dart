import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:holobooth/assets/assets.dart';

enum PortalMode {
  portrait,
  landscape,
  mobile;

  PortalModeData get data {
    switch (this) {
      case PortalMode.portrait:
        return PortalModeData(
          texturePath: Assets.animations.mobilePortalSpritesheet.path,
          textureSize: Vector2(650, 850),
          thumbSize: Vector2(322, 378),
          thumbOffset: Vector2(168, 104),
          frameAmout: 90,
          amountPerRow: 10,
        );
      case PortalMode.landscape:
        return PortalModeData(
          texturePath: Assets.animations.desktopPortalSpritesheet.path,
          textureSize: Vector2(710, 750),
          thumbSize: Vector2(498, 280),
          thumbOffset: Vector2(100, 96),
          frameAmout: 90,
          amountPerRow: 10,
        );
      case PortalMode.mobile:
        return PortalModeData(
          texturePath: Assets.animations.smallPortalAnimation.path,
          textureSize: Vector2(325, 425),
          thumbSize: Vector2(162, 190),
          thumbOffset: Vector2(84, 52),
          frameAmout: 72,
          amountPerRow: 12,
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
    required this.frameAmout,
    required this.amountPerRow,
  });

  final String texturePath;
  final Vector2 textureSize;
  final Vector2 thumbSize;
  final Vector2 thumbOffset;
  final int frameAmout;
  final int amountPerRow;
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
    Future<Image> Function(Uint8List)? decodeImage,
    Future<SpriteAnimation> Function(String, SpriteAnimationData)?
        loadAnimation,
  }) {
    _decodeImageFromList = decodeImage ?? decodeImageFromList;
    _loadAnimation = loadAnimation ?? loadSpriteAnimation;
  }

  final PortalMode mode;

  final Uint8List imageBytes;

  final VoidCallback onComplete;

  late final Future<Image> Function(Uint8List) _decodeImageFromList;

  late final Future<SpriteAnimation> Function(String, SpriteAnimationData)
      _loadAnimation;

  @override
  Future<void> onLoad() async {
    final data = mode.data;
    images.prefix = '';
    final image = await _decodeImageFromList(imageBytes);

    final thumb = Sprite(image);

    final animation = await _loadAnimation(
      data.texturePath,
      SpriteAnimationData.sequenced(
        amount: data.frameAmout,
        amountPerRow: data.amountPerRow,
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

    /// Play
    final platImageSprite = await loadSprite(Assets.icons.playIcon.path);

    animation.onComplete = () {
      onComplete();
      frameComponent.add(
        ThumbComponent(
          sprite: thumb,
          data: data,
          children: [
            PlayComponent(sprite: platImageSprite),
          ],
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
    super.children,
  });

  final Sprite sprite;
  final PortalModeData data;
  late final Rect clipRect;
  late final Vector2 renderSize;

  @override
  Future<void> onLoad() async {
    size = data.thumbSize.clone();

    final imageSize = Vector2(
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

    final rateX = data.thumbSize.x / imageSize.x;
    final rateY = data.thumbSize.y / imageSize.y;

    final rate = math.max(rateX, rateY);

    renderSize = imageSize * rate;
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

@visibleForTesting
class PlayComponent extends SpriteComponent with ParentIsA<PositionComponent> {
  PlayComponent({
    required super.sprite,
  });

  @override
  Future<void> onLoad() async {
    final dimension = math.max(
      parent.size.x,
      parent.size.y,
    );
    size = Vector2.all(dimension * .22);

    anchor = Anchor.center;
    position = parent.size / 2;
  }
}
