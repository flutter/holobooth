import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

GifCompositorPlatform get _platform => GifCompositorPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
