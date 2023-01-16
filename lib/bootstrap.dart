// ignore_for_file: avoid_print
import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';
import 'package:io_photobooth/landing/loading_indicator_io.dart'
    if (dart.library.html) 'package:io_photobooth/landing/loading_indicator_web.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

Future<void> bootstrap({
  required String convertUrl,
  required FirebaseOptions firebaseOptions,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    print(details.stack);
  };

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  final authenticationRepository = AuthenticationRepository(
    firebaseAuth: FirebaseAuth.instance,
  );
  await authenticationRepository.signInAnonymously();

  final avatarDetectorRepository = AvatarDetectorRepository();
  final convertRepository = ConvertRepository(
    url: convertUrl,
  );

  unawaited(
    Future.wait([
      Flame.images.load('holobooth_avatar.png'),
    ]),
  );

  runZonedGuarded(
    () => runApp(
      App(
        authenticationRepository: authenticationRepository,
        avatarDetectorRepository: avatarDetectorRepository,
        convertRepository: convertRepository,
      ),
    ),
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );

  SchedulerBinding.instance.addPostFrameCallback(
    (_) => removeLoadingIndicator(),
  );
}
