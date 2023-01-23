import 'package:holobooth/assets/assets.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

typedef RiveFileLoader = Future<RiveFile> Function(String assetPath);

class RiveFileManager {
  RiveFileManager({RiveFileLoader? loadRiveFile})
      : _loadRiveFile = loadRiveFile ?? RiveFile.asset;

  final RiveFileLoader _loadRiveFile;
  final Map<String, RiveFile> _files = {};
  final Map<String, Future<void>> _futures = {};

  RiveFile? getFile(String assetPath) {
    return _files[assetPath];
  }

  Future<RiveFile> loadFile(String assetPath) async {
    if (_futures.containsKey(assetPath)) {
      await _futures[assetPath];
      return _files[assetPath]!;
    }

    final file = _loadRiveFile(assetPath).then((loadedFile) {
      _files[assetPath] = loadedFile;
      return loadedFile;
    });
    _futures[assetPath] = file;
    return file;
  }

  Future<void> loadAllAssets([PlatformHelper? platformHelper]) async {
    final isMobile = (platformHelper ?? PlatformHelper()).isMobile;
    final dashPath = isMobile
        ? Assets.animations.dashMobile.path
        : Assets.animations.dashDesktop.path;

    final sparkyPath = isMobile
        ? Assets.animations.sparkyMobile.path
        : Assets.animations.sparkyDesktop.path;

    // The order of these files is important. The first file is the one that
    // will be selected by default when the animation is loaded.
    await loadFile(dashPath);
    if (!isMobile) await loadFile(Assets.animations.bg00.path);
    await loadFile(sparkyPath);
    if (!isMobile) {
      await Future.wait([
        loadFile(Assets.animations.bg01.path),
        loadFile(Assets.animations.bg02.path),
        loadFile(Assets.animations.bg03.path),
        loadFile(Assets.animations.bg04.path),
        loadFile(Assets.animations.bg05.path),
        loadFile(Assets.animations.bg06.path),
        loadFile(Assets.animations.bg07.path),
        loadFile(Assets.animations.bg08.path),
      ]);
    }
  }
}
