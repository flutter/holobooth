// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

class _GifCompositorMock extends GifCompositorPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GifCompositorPlatformInterface', () {
    late GifCompositorPlatform gifCompositorPlatform;

    setUp(() {
      gifCompositorPlatform = _GifCompositorMock();
      GifCompositorPlatform.instance = gifCompositorPlatform;
    });

    group('composite', () {
      test('throws an UnimplementedError', () async {
        await expectLater(
          () async => GifCompositorPlatform.instance.composite(
            images: <Uint8List>[],
            fileName: '',
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
