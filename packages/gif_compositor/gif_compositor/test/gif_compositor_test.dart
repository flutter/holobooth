// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor/gif_compositor.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockXFile extends Mock implements XFile {}

class _MockGifCompositorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GifCompositorPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$GifCompositor', () {
    const testFileName = 'output.gif';
    const testImages = <Uint8List>[];

    late GifCompositorPlatform gifCompositorPlatform;
    late XFile xfile;

    setUp(() {
      gifCompositorPlatform = _MockGifCompositorPlatform();
      GifCompositorPlatform.instance = gifCompositorPlatform;

      xfile = _MockXFile();
    });

    group('composite', () {
      test(
        'returns correct name when platform implementation exists',
        () async {
          when(
            () => gifCompositorPlatform.composite(
              images: testImages,
              fileName: testFileName,
            ),
          ).thenAnswer((_) async => xfile);

          final result = await GifCompositor.composite(
            images: testImages,
            fileName: testFileName,
          );
          expect(result, equals(xfile));
        },
      );
    });
  });
}
