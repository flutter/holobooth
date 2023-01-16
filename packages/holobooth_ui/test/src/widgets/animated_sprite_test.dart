// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui show Image;

import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class __MockImages extends Mock implements Images {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AnimatedSprite', () {
    late Images images;
    late ui.Image image;

    setUp(() async {
      images = __MockImages();
      Flame.images = images;
      image = await decodeImageFromList(Uint8List.fromList(transparentImage));
    });

    testWidgets('renders AppCircularProgressIndicator when loading asset',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'does not render AppCircularProgressIndicator'
        ' when loading asset and showLoadingIndicator is false',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
          showLoadingIndicator: false,
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsNothing);
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (loop)',
        (tester) async {
      await tester.runAsync(() async {
        final images = __MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites:
                    Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (oneTime)',
        (tester) async {
      await tester.runAsync(() async {
        final images = __MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites:
                    Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
                mode: AnimationMode.oneTime,
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });
  });
}
