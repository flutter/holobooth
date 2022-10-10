// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:gif_compositor_platform_interface/src/method_channel_gif_compositor.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of gif_compositor must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `GifCompositor`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [GifCompositorPlatform] methods.
abstract class GifCompositorPlatform extends PlatformInterface {
  /// Constructs a GifCompositorPlatform.
  GifCompositorPlatform() : super(token: _token);

  static final Object _token = Object();

  static GifCompositorPlatform _instance = MethodChannelGifCompositor();

  /// The default instance of [GifCompositorPlatform] to use.
  ///
  /// Defaults to [MethodChannelGifCompositor].
  static GifCompositorPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [GifCompositorPlatform] when they register themselves.
  static set instance(GifCompositorPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
