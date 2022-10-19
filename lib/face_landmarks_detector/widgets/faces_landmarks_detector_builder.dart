import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/face_landmarks_detector/face_landmarks_detector.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class FacesLandmarksDetectorBuilder extends StatelessWidget {
  const FacesLandmarksDetectorBuilder({
    super.key,
    required this.cameraController,
    required this.builder,
  });

  final CameraController cameraController;

  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceLandmarksDetectorBloc()
        ..add(const FaceLandmarksDetectorInitialized()),
      child: FacesLandmarksDetectorBuilderView(
        builder: builder,
        cameraController: cameraController,
      ),
    );
  }
}

class FacesLandmarksDetectorBuilderView extends StatelessWidget {
  const FacesLandmarksDetectorBuilderView({
    super.key,
    required this.cameraController,
    required this.builder,
  });

  final CameraController cameraController;
  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FaceLandmarksDetectorBloc, FaceLandmarksDetectorState>(
      listener: (context, state) async {
        if (state is FaceLandmarksDetectorLoaded) {
          await cameraController.startImageStream((image) {
            context
                .read<FaceLandmarksDetectorBloc>()
                .add(FaceLandmarksDetectorEstimateRequested(image));
          });
        }
      },
      builder: (context, state) {
        if (state is FaceLandmarksDetectorFacesDetected) {
          return builder(context, state.faces);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
