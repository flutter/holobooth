import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraDescription extends Mock implements CameraDescription {}

class _MockXFile extends Mock implements XFile {}

class _MockPhotoBoothBloc extends MockBloc<PhotoBoothEvent, PhotoBoothState>
    implements PhotoBoothBloc {}

class _FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  String get data => '';

  @override
  PhotoConstraint get constraint => PhotoConstraint();
}

void main() {
  const cameraId = 1;
  late CameraPlatform cameraPlatform;
  late XFile xfile;
  late PhotoboothCameraImage image;

  setUp(() {
    xfile = _MockXFile();
    when(() => xfile.path).thenReturn('');

    cameraPlatform = _MockCameraPlatform();
    CameraPlatform.instance = cameraPlatform;

    final event = CameraInitializedEvent(
      cameraId,
      1,
      1,
      ExposureMode.auto,
      true,
      FocusMode.auto,
      true,
    );

    image = PhotoboothCameraImage(
      data: xfile.path,
      constraint: PhotoConstraint(
        width: event.previewWidth,
        height: event.previewHeight,
      ),
    );

    final cameraDescription = _MockCameraDescription();
    when(() => cameraPlatform.availableCameras())
        .thenAnswer((_) async => [cameraDescription]);
    when(
      () => cameraPlatform.createCamera(
        cameraDescription,
        ResolutionPreset.max,
      ),
    ).thenAnswer((_) async => 1);
    when(() => cameraPlatform.initializeCamera(cameraId))
        .thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.onCameraInitialized(cameraId)).thenAnswer(
      (_) => Stream.value(event),
    );
    when(() => CameraPlatform.instance.onDeviceOrientationChanged())
        .thenAnswer((_) => Stream.empty());
    when(() => cameraPlatform.takePicture(any()))
        .thenAnswer((_) async => xfile);
    when(() => cameraPlatform.buildPreview(cameraId)).thenReturn(SizedBox());
    when(() => cameraPlatform.pausePreview(cameraId))
        .thenAnswer((_) => Future.value());
    when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => <void>{});
    when(() => cameraPlatform.onStreamedFrameAvailable(any()))
        .thenAnswer((_) => Stream.empty());
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('PhotoBoothPage', () {
    test('is routable', () {
      expect(PhotoBoothPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets(
      'renders PhotoBoothView',
      (WidgetTester tester) async {
        await tester.pumpApp(PhotoBoothPage());
        expect(find.byType(PhotoBoothView), findsOneWidget);
      },
    );
  });

  group('PhotoBoothView', () {
    late PhotoBoothBloc photoBoothBloc;

    setUp(() {
      photoBoothBloc = _MockPhotoBoothBloc();
      when(
        () => photoBoothBloc.state,
      ).thenReturn(PhotoBoothState.empty());
    });

    setUpAll(() {
      registerFallbackValue(_FakePhotoboothCameraImage());
    });

    testWidgets(
      'renders empty SizedBox if any unexpected error finding camera',
      (WidgetTester tester) async {
        when(() => cameraPlatform.availableCameras()).thenThrow(Exception());
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc,
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(PhotoBoothView.cameraErrorViewKey),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders PhotoboothError if any CameraException finding camera',
      (WidgetTester tester) async {
        when(() => cameraPlatform.availableCameras())
            .thenThrow(CameraException('', ''));
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc,
        );
        await tester.pumpAndSettle();
        expect(find.byType(PhotoboothError), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to MultipleCaptureViewerPage when isFinished',
      (WidgetTester tester) async {
        final images = UnmodifiableListView([
          for (var i = 0; i < PhotoBoothState.totalNumberOfPhotos; i++)
            _FakePhotoboothCameraImage(),
        ]);
        whenListen(
          photoBoothBloc,
          Stream.value(PhotoBoothState(images: images)),
        );
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc,
        );
        await tester.pumpAndSettle();
        expect(find.byType(MultipleCaptureViewerPage), findsOneWidget);
      },
    );

    testWidgets(
      'adds PhotoBoothOnPhotoTaken when onShutter is called',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PhotoBoothView(),
          photoBoothBloc,
        );
        await tester.pumpAndSettle();
        final multipleShutterButton = tester.widget<MultipleShutterButton>(
          find.byType(MultipleShutterButton),
        );

        await multipleShutterButton.onShutter();
        await tester.pumpAndSettle();
        verify(
          () => photoBoothBloc.add(
            PhotoBoothOnPhotoTaken(
              image: image,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('renders ItemSelectorButton', (tester) async {
      await tester.pumpSubject(PhotoBoothView(), photoBoothBloc);
      await tester.pumpAndSettle();
      expect(
        find.byKey(SelectionButtons.propsSelectorKey),
        findsOneWidget,
      );
    });

    testWidgets('itemSelectorButton renders itemSelectorDrawer when pressed',
        (tester) async {
      await tester.pumpSubject(PhotoBoothView(), photoBoothBloc);
      await tester.pumpAndSettle();

      final itemSelectorButton = find.byKey(SelectionButtons.propsSelectorKey);
      await tester.tap(itemSelectorButton);
      await tester.pumpAndSettle();
      expect(
        find.byKey(PhotoBoothView.endDrawerKey),
        findsOneWidget,
      );
    });

    testWidgets('Item prints when selected', (tester) async {
      await tester.pumpSubject(PhotoBoothView(), photoBoothBloc);
      await tester.pumpAndSettle();

      final itemSelectorButton = find.byKey(SelectionButtons.propsSelectorKey);
      await tester.tap(itemSelectorButton);
      await tester.pumpAndSettle();
      expect(
        find.byKey(PhotoBoothView.endDrawerKey),
        findsOneWidget,
      );
      await tester.tap(
        find
            .descendant(
              of: find.byKey(
                PhotoBoothView.endDrawerKey,
              ),
              matching: find.byType(ColoredBox),
            )
            .first,
        // TODO(laura177): test onSelected of ItemSelectorDrawer
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoBoothView subject,
    PhotoBoothBloc multipleCaptureBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: multipleCaptureBloc),
          ],
          child: subject,
        ),
      );
}
