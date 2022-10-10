// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

/// The Web implementation of [GifCompositorPlatform].
class GifCompositorWeb extends GifCompositorPlatform {
  /// Registers this class as the default instance of [GifCompositorPlatform]
  static void registerWith([Object? registrar]) {
    GifCompositorPlatform.instance = GifCompositorWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
