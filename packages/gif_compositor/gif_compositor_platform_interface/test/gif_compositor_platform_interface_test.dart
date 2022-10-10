// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

class GifCompositorMock extends GifCompositorPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GifCompositorPlatformInterface', () {
    late GifCompositorPlatform gifCompositorPlatform;

    setUp(() {
      gifCompositorPlatform = GifCompositorMock();
      GifCompositorPlatform.instance = gifCompositorPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await GifCompositorPlatform.instance.getPlatformName(),
          equals(GifCompositorMock.mockPlatformName),
        );
      });
    });
  });
}
