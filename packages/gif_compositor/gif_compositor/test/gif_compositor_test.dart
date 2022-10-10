// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor/gif_compositor.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGifCompositorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GifCompositorPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GifCompositor', () {
    late GifCompositorPlatform gifCompositorPlatform;

    setUp(() {
      gifCompositorPlatform = MockGifCompositorPlatform();
      GifCompositorPlatform.instance = gifCompositorPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => gifCompositorPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => gifCompositorPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
