import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

class _MockLoadRiveFile extends Mock {
  Future<RiveFile> call(String path);
}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RiveFileManager', () {
    late RiveFileLoader loadRiveFile;
    late RiveFile riveFile;

    setUp(() async {
      loadRiveFile = _MockLoadRiveFile().call;
      riveFile = await RiveFile.asset(Assets.animations.dashMobile.path);

      when(() => loadRiveFile.call(any())).thenAnswer((_) async => riveFile);
    });

    group('loadFile', () {
      test('loads the file', () async {
        final subject = RiveFileManager(loadRiveFile: loadRiveFile);

        final file = await subject.loadFile('assetPath');

        expect(file, equals(riveFile));

        verify(() => loadRiveFile.call('assetPath')).called(1);
      });

      test('only loads the file once', () async {
        final subject = RiveFileManager(loadRiveFile: loadRiveFile);

        final file1 = subject.loadFile('assetPath');
        final file2 = subject.loadFile('assetPath');
        final file3 = subject.loadFile('assetPath');

        expect(await file1, equals(riveFile));
        expect(await file2, equals(riveFile));
        expect(await file3, equals(riveFile));

        verify(() => loadRiveFile.call('assetPath')).called(1);
      });
    });

    group('getFile', () {
      test('returns null when the file is not loaded', () {
        final subject = RiveFileManager(loadRiveFile: loadRiveFile);

        final file = subject.getFile('assetPath');

        expect(file, isNull);
      });

      test('returns the file when the file is loaded', () async {
        final subject = RiveFileManager(loadRiveFile: loadRiveFile);

        await subject.loadFile('assetPath');
        final file = subject.getFile('assetPath');

        expect(file, equals(riveFile));
      });
    });

    group('loadAllAssets', () {
      late PlatformHelper platformHelper;

      setUp(() {
        platformHelper = _MockPlatformHelper();
      });

      group('on mobile', () {
        setUp(() {
          when(() => platformHelper.isMobile).thenReturn(true);
        });

        test('loads only mobile dash and sparky', () async {
          final subject = RiveFileManager(loadRiveFile: loadRiveFile);
          await subject.loadAllAssets(platformHelper);

          verify(() => loadRiveFile.call(Assets.animations.dashMobile.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.sparkyMobile.path))
              .called(1);
          verifyNever(
            () => loadRiveFile.call(Assets.animations.dashDesktop.path),
          );
          verifyNever(
            () => loadRiveFile.call(Assets.animations.sparkyDesktop.path),
          );
          verifyNever(() => loadRiveFile.call(Assets.animations.bg00.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg01.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg02.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg03.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg04.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg05.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg06.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg07.path));
          verifyNever(() => loadRiveFile.call(Assets.animations.bg08.path));
        });
      });

      group('on desktop', () {
        setUp(() {
          when(() => platformHelper.isMobile).thenReturn(false);
        });

        test('loads all backgrounds and desktop dash and sparky', () async {
          final subject = RiveFileManager(loadRiveFile: loadRiveFile);
          await subject.loadAllAssets(platformHelper);

          verify(() => loadRiveFile.call(Assets.animations.bg00.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg01.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg02.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg03.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg04.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg05.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg06.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg07.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.bg08.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.dashDesktop.path))
              .called(1);
          verify(() => loadRiveFile.call(Assets.animations.sparkyDesktop.path))
              .called(1);
          verifyNever(
            () => loadRiveFile.call(Assets.animations.dashMobile.path),
          );
          verifyNever(
            () => loadRiveFile.call(Assets.animations.sparkyMobile.path),
          );
        });
      });
    });
  });
}
