// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/face_landmarks_detector/face_landmarks_detector.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class FacesLandmarksDetectorBuilder extends StatelessWidget {
  const FacesLandmarksDetectorBuilder({
    super.key,
    required this.videoElement,
    required this.builder,
  });

  final html.VideoElement videoElement;
  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceLandmarksDetectorBloc()
        ..add(const FaceLandmarksDetectorInitialized()),
      child: FacesLandmarksDetectorBuilderView(
        builder: builder,
        videoElement: videoElement,
      ),
    );
  }
}

class FacesLandmarksDetectorBuilderView extends StatelessWidget {
  const FacesLandmarksDetectorBuilderView(
      {super.key, required this.videoElement, required this.builder});

  final html.VideoElement videoElement;
  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FaceLandmarksDetectorBloc, FaceLandmarksDetectorState>(
      listener: (context, state) {
        if (state is FaceLandmarksDetectorLoaded) {
          context
              .read<FaceLandmarksDetectorBloc>()
              .add(FaceLandmarksDetectorEstimateRequested(videoElement));
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
