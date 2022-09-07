// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

extension on WidgetTester {
  Future<void> pumpSubject(
    AnimatedPhotoboothPhoto subject, {
    PhotoboothBloc? photoboothBloc,
  }) async {
    final bloc = photoboothBloc ?? _MockPhotoboothBloc();
    if (photoboothBloc == null) {
      when(() => bloc.state).thenReturn(PhotoboothState());
    }

    await pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider<PhotoboothBloc>.value(
          value: bloc,
          child: Builder(builder: (_) => subject),
        ),
      ),
    );
  }
}

void main() {
  group('AnimatedPhotoboothPhoto', () {
    late PhotoboothBloc photoboothBloc;

    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      when(() => photoboothBloc.state).thenReturn(PhotoboothState());
    });

    test('can be instantiated', () {
      expect(
        AnimatedPhotoboothPhoto(
          image: CameraImage(data: '', width: 1, height: 1),
        ),
        isA<AnimatedPhotoboothPhoto>(),
      );
    });

    group('renders', () {
      testWidgets('successfully', (tester) async {
        final subject = AnimatedPhotoboothPhoto(
          image: CameraImage(data: '', width: 1, height: 1),
        );
        await tester.pumpSubject(subject);
        expect(find.byWidget(subject), findsOneWidget);
      });
    });

    group('golden', () {
      const tags = 'golden';
      String goldenPath(String fileName, {String useCase = ''}) =>
          'goldens/$useCase/$fileName.png';

      testWidgets(
        'animates when the aspect ratio is landscape',
        (tester) async {
          final photoboothBloc = _MockPhotoboothBloc();
          when(() => photoboothBloc.state).thenReturn(PhotoboothState());

          const sprite = AnimatedPhotoboothPhotoLandscape.sprite;
          final subject = AnimatedPhotoboothPhoto(
            image: CameraImage(data: '', width: 1, height: 1),
          );
          await tester.pumpSubject(subject);

          final frameDuration = Duration(
            milliseconds:
                (sprite.sprites.stepTime * Duration.millisecondsPerSecond)
                    .round(),
          );
          for (var frame = 0; frame < sprite.sprites.frames; frame++) {
            await tester.pump(frameDuration);
            await expectLater(
              find.byWidget(subject),
              matchesGoldenFile(
                goldenPath('frame$frame', useCase: 'landscape'),
              ),
            );
          }
        },
        tags: tags,
      );

      testWidgets(
        'animates when the aspect ratio is portrait',
        (tester) async {
          final photoboothBloc = _MockPhotoboothBloc();
          when(() => photoboothBloc.state).thenReturn(
            PhotoboothState(aspectRatio: PhotoboothAspectRatio.portrait),
          );

          const sprite = AnimatedPhotoboothPhotoPortrait.sprite;
          final subject = AnimatedPhotoboothPhoto(
            image: CameraImage(data: '', width: 1, height: 1),
          );
          await tester.pumpSubject(subject);

          final frameDuration = Duration(
            milliseconds:
                (sprite.sprites.stepTime * Duration.millisecondsPerSecond)
                    .round(),
          );
          for (var frame = 0; frame < sprite.sprites.frames; frame++) {
            await tester.pump(frameDuration);
            await expectLater(
              find.byWidget(subject),
              matchesGoldenFile(
                goldenPath('frame$frame', useCase: 'portrait'),
              ),
            );
          }
        },
        tags: tags,
      );
    });
  });
}
