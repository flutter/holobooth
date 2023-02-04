import 'dart:typed_data';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:rive/rive.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockDownloadRepository extends Mock implements DownloadRepository {}

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {
  _MockAvatarDetectorRepository() {
    registerFallbackValue(
      tf.ImageData(bytes: Uint8List(0), size: tf.Size(0, 0)),
    );

    when(preloadLandmarksModel).thenAnswer((_) => Future.value());
    // ignore: inference_failure_on_function_invocation
    when(() => detectAvatar(any())).thenAnswer((_) async => null);
  }
}

class _MockMuteSoundBloc extends MockBloc<MuteSoundEvent, MuteSoundState>
    implements MuteSoundBloc {
  _MockMuteSoundBloc() {
    when(() => state).thenReturn(MuteSoundState(isMuted: false));
  }
}

class _MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {
  _MockCameraBloc() {
    when(() => state).thenReturn(CameraState());
  }
}

class _FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

class _MockAnalyticsRepository extends Mock implements AnalyticsRepository {
  _MockAnalyticsRepository() {
    registerFallbackValue(_FakeAnalyticsEvent());

    when(() => trackEvent(any())).thenAnswer((_) {});
  }
}

class _FakeRiveFileManager extends Fake implements RiveFileManager {
  @override
  RiveFile? getFile(String assetPath) => null;

  @override
  Future<RiveFile> loadFile(String assetPath) => RiveFile.asset(assetPath);
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AvatarDetectorRepository? avatarDetectorRepository,
    ConvertRepository? convertRepository,
    DownloadRepository? downloadRepository,
    AnalyticsRepository? analyticsRepository,
    MuteSoundBloc? muteSoundBloc,
    CameraBloc? cameraBloc,
    RiveFileManager? riveFileManager,
  }) async {
    return mockNetworkImages(() async {
      return pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value:
                  avatarDetectorRepository ?? _MockAvatarDetectorRepository(),
            ),
            RepositoryProvider.value(
              value: convertRepository ?? _MockConvertRepository(),
            ),
            RepositoryProvider.value(
              value: downloadRepository ?? _MockDownloadRepository(),
            ),
            RepositoryProvider.value(
              value: analyticsRepository ?? _MockAnalyticsRepository(),
            ),
            RepositoryProvider.value(
              value: riveFileManager ?? _FakeRiveFileManager(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => muteSoundBloc ?? _MockMuteSoundBloc(),
              ),
              BlocProvider(
                create: (context) => cameraBloc ?? _MockCameraBloc(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: widget,
            ),
          ),
        ),
      );
    });
  }
}
