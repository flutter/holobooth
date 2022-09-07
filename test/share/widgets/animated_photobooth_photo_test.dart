// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

void main() {
  group('AnimatedPhotoboothPhoto', () {
    test('can be instantiated', () {
      expect(
        AnimatedPhotoboothPhoto(
          image: CameraImage(data: '', width: 1, height: 1),
        ),
        isA<AnimatedPhotoboothPhoto>(),
      );
    });
  });
}
