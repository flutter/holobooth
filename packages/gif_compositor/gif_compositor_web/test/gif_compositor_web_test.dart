// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:gif_compositor_web/gif_compositor_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GifCompositorWeb', () {
    const kPlatformName = 'Web';
    late GifCompositorWeb gifCompositor;

    setUp(() async {
      gifCompositor = GifCompositorWeb();
    });

    test('can be registered', () {
      GifCompositorWeb.registerWith();
      expect(GifCompositorPlatform.instance, isA<GifCompositorWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await gifCompositor.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
