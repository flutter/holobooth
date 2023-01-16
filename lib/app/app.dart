import 'package:authentication_repository/authentication_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.avatarDetectorRepository,
    required this.convertRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final AvatarDetectorRepository avatarDetectorRepository;
  final ConvertRepository convertRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: avatarDetectorRepository),
        RepositoryProvider.value(value: convertRepository),
      ],
      child: AnimatedFadeIn(
        child: ResponsiveLayoutBuilder(
          small: (_, __) => _App(theme: PhotoboothTheme.small),
          medium: (_, __) => _App(theme: PhotoboothTheme.medium),
          large: (_, __) => _App(theme: PhotoboothTheme.standard),
        ),
      ),
    );
  }
}

class _App extends StatelessWidget {
  const _App({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I/O Photo Booth',
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LandingPage(),
    );
  }
}
