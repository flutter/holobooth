import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class CameraSelectionDropdown extends StatelessWidget {
  const CameraSelectionDropdown({super.key});

  @visibleForTesting
  static const noCameraIconKey = Key('no_camera_icon');

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      buildWhen: (previous, current) =>
          previous.availableCameras != current.availableCameras ||
          previous.cameraError != current.cameraError,
      builder: (_, state) {
        if (state.cameraError != null) {
          final error = state.cameraError;
          if (error is CameraException) {
            return CameraErrorView(
              key: cameraErrorViewKey,
              error: error,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: HoloBoothColors.white),
            );
          }
        }

        if (state.availableCameras == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
              color: HoloBoothColors.convertLoading,
            ),
          );
        }

        final cameras = state.availableCameras;
        if (cameras == null || cameras.isEmpty) {
          return const Icon(
            key: noCameraIconKey,
            Icons.videocam_off,
            color: HoloBoothColors.white,
          );
        }

        final dropdownItems = cameras
            .map(
              (camera) => DropdownMenuItem(
                value: camera,
                child: Text(
                  camera.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: HoloBoothColors.white),
                ),
              ),
            )
            .toList();

        return BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) => DropdownButton<CameraDescription>(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            value: state.camera,
            dropdownColor: HoloBoothColors.darkPurple,
            items: dropdownItems,
            onChanged: (value) =>
                context.read<CameraBloc>().add(CameraChanged(value!)),
          ),
        );
      },
    );
  }
}
