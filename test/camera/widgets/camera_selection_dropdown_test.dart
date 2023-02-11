import 'package:bloc_test/bloc_test.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart'
    hide CameraEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class _MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

void main() {
  late CameraPlatform cameraPlatform;
  late CameraBloc cameraBloc;
  const camerasStub = [
    CameraDescription(
      name: 'Camera 1',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
    CameraDescription(
      name: 'Camera 2',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
  ];

  setUp(() {
    cameraBloc = _MockCameraBloc();
    cameraPlatform = _MockCameraPlatform();
    CameraPlatform.instance = cameraPlatform;

    when(cameraPlatform.availableCameras).thenAnswer((_) async => camerasStub);
    when(() => cameraBloc.state).thenReturn(
      CameraState(
        camera: camerasStub[0],
        availableCameras: camerasStub,
      ),
    );
  });

  tearDown(() {
    CameraPlatform.instance = _MockCameraPlatform();
  });

  group('CameraSelectionDropdown', () {
    testWidgets(
        'renders CircularProgressIndicator while availableCameras() is running',
        (tester) async {
      when(() => cameraBloc.state).thenReturn(
        CameraState(),
      );

      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error view when available cameras list is empty',
        (tester) async {
      when(() => cameraBloc.state)
          .thenReturn(CameraState(availableCameras: const []));

      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      await tester.pump();

      expect(
        find.byKey(CameraSelectionDropdown.cameraErrorViewKey),
        findsOneWidget,
      );
    });

    testWidgets('renders error view when there is camera error',
        (tester) async {
      when(() => cameraBloc.state).thenReturn(
        CameraState(cameraError: CameraException('CameraAccessDenied', '')),
      );

      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      await tester.pump();

      expect(
        find.byKey(CameraSelectionDropdown.cameraErrorViewKey),
        findsOneWidget,
      );
    });

    testWidgets('displays dropdown button with the list of available cameras',
        (tester) async {
      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      await tester.pump();

      expect(find.byType(DropdownButton<CameraDescription>), findsOneWidget);

      for (var i = 0; i < camerasStub.length; i++) {
        expect(find.text(camerasStub[i].name), findsOneWidget);
      }
    });

    testWidgets('emits camera change event when dropdown value changes',
        (tester) async {
      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<CameraDescription>));
      await tester.pumpAndSettle();

      await tester.tap(find.text(camerasStub[1].name).last);
      await tester.pumpAndSettle();

      verify(() => cameraBloc.add(CameraChanged(camerasStub[1]))).called(1);
    });

    testWidgets('does not rebuild when camera changed', (tester) async {
      await tester.pumpSubject(
        const CameraSelectionDropdown(),
        cameraBloc: cameraBloc,
      );
      await tester.pump();

      final blocBuilder = find
          .byType(BlocBuilder<CameraBloc, CameraState>)
          .evaluate()
          .first
          .widget as BlocBuilder<CameraBloc, CameraState>;

      expect(
        blocBuilder.buildWhen!(
          cameraBloc.state,
          cameraBloc.state.copyWith(camera: camerasStub[1]),
        ),
        equals(false),
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CameraSelectionDropdown subject, {
    CameraBloc? cameraBloc,
  }) {
    return pumpApp(
      Scaffold(
        body: BlocProvider(
          create: (_) => cameraBloc ?? _MockCameraBloc(),
          child: subject,
        ),
      ),
    );
  }
}
