// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

void main() {
  late PhotoboothCameraImage image;
  final bytes = Uint8List.fromList(transparentImage);

  late PhotoboothBloc photoboothBloc;

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    image = _MockPhotoboothCameraImage();
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('ShareDialog', () {
    testWidgets('displays heading', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byKey(Key('shareDialog_heading')), findsOneWidget);
    });

    testWidgets('displays subheading', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byKey(Key('shareDialog_subheading')), findsOneWidget);
    });

    testWidgets('displays a TwitterButton', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(TwitterButton), findsOneWidget);
    });

    testWidgets('displays a FacebookButton', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(FacebookButton), findsOneWidget);
    });

    testWidgets('taps on close will dismiss the popup', (tester) async {
      await tester.pumpApp(
        Material(child: ShareDialog(image: bytes)),
        photoboothBloc: photoboothBloc,
      );
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsNothing);
    });
  });
}
