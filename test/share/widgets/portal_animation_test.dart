import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Uint8List imageBytes;

  setUpAll(() async {
    final image = await createTestImage(height: 8, width: 8);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    imageBytes = byteData!.buffer.asUint8List();
  });

  group('PortalAnimation', () {
    testWithGame(
      'loads the game correctly when in portrait mode',
      () => PortalGame(
        mode: PortalMode.portrait,
        imageBytes: imageBytes,
        onComplete: () {},
      ),
      (game) async {
        await game.ready();
        expect(
          game.firstChild<SpriteAnimationComponent>(),
          isNotNull,
        );
      },
    );

    testWithGame(
      'loads the game correctly when in landscape mode',
      () => PortalGame(
        mode: PortalMode.landscape,
        imageBytes: imageBytes,
        onComplete: () {},
      ),
      (game) async {
        await game.ready();
        expect(
          game.firstChild<SpriteAnimationComponent>(),
          isNotNull,
        );
      },
    );

    testWithGame(
      'adds the thumb after the sprite animation has finished',
      () => PortalGame(
        mode: PortalMode.landscape,
        imageBytes: imageBytes,
        onComplete: () {},
      ),
      (game) async {
        await game.ready();
        game.update(10);
        await game.ready();
        expect(
          game.descendants().whereType<ThumbComponent>(),
          isNotEmpty,
        );
      },
    );

    testWithGame(
      'adds the play icon after the sprite animation has finished',
      () => PortalGame(
        mode: PortalMode.landscape,
        imageBytes: imageBytes,
        onComplete: () {},
      ),
      (game) async {
        await game.ready();
        game.update(10);
        await game.ready();
        expect(
          game.descendants().whereType<PlayComponent>(),
          isNotEmpty,
        );
      },
    );

    group('ThumbComponent', () {
      testWithGame(
        'renders correctly',
        FlameGame.new,
        (game) async {
          final image = await decodeImageFromList(imageBytes);
          final thumb = ThumbComponent(
            sprite: Sprite(image),
            data: PortalMode.portrait.data,
            children: [PlayComponent(sprite: Sprite(image))],
          );

          await game.ensureAdd(thumb);

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          game.render(canvas);
          final picture = recorder.endRecording();
          expect(picture, isNotNull);
        },
      );
    });
  });
}
