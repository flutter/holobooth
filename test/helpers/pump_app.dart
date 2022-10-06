import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:photos_repository/photos_repository.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    PhotosRepository? photosRepository,
  }) async {
    return mockNetworkImages(() async {
      return pumpWidget(
        RepositoryProvider.value(
          value: photosRepository ?? MockPhotosRepository(),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      );
    });
  }
}
