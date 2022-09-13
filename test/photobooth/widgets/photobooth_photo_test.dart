// ignore_for_file: prefer_const_constructors
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

void main() {
  late PhotoboothCameraImage image;
  late PhotoboothBloc photoboothBloc;

  setUp(() {
    photoboothBloc = MockPhotoboothBloc();
    image = _MockPhotoboothCameraImage();
    when(() => image.data).thenReturn('');
    when(() => photoboothBloc.state).thenReturn(PhotoboothState(image: image));
  });

  group('PhotoboothPhoto', () {
    testWidgets('displays PreviewImage', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: image.data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays CharactersLayer', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: image.data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(CharactersLayer), findsOneWidget);
    });

    testWidgets('displays StickersLayer', (tester) async {
      await tester.pumpApp(
        PhotoboothPhoto(image: image.data),
        photoboothBloc: photoboothBloc,
      );
      expect(find.byType(StickersLayer), findsOneWidget);
    });
  });
}
