import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/landing/landing.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.avatarDetectorRepository,
    required this.convertRepository,
    required this.downloadRepository,
    required this.analyticsRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final AvatarDetectorRepository avatarDetectorRepository;
  final ConvertRepository convertRepository;
  final DownloadRepository downloadRepository;
  final AnalyticsRepository analyticsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: avatarDetectorRepository),
        RepositoryProvider.value(value: convertRepository),
        RepositoryProvider.value(value: downloadRepository),
        RepositoryProvider.value(value: analyticsRepository),
        RepositoryProvider(
          lazy: false,
          create: (context) => RiveFileManager()..loadAllAssets(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MuteSoundBloc()),
          BlocProvider(
            create: (context) => CameraBloc()..add(CameraStarted()),
          ),
        ],
        child: AnimatedFadeIn(
          child: ResponsiveLayoutBuilder(
            small: (_, __) => _AppView(theme: HoloboothTheme.small),
            medium: (_, __) => _AppView(theme: HoloboothTheme.medium),
            large: (_, __) => _AppView(theme: HoloboothTheme.standard),
          ),
        ),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holobooth',
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LandingPage(),
    );
  }
}
