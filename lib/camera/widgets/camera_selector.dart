import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class CameraSelector extends StatelessWidget {
  const CameraSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availableCameras(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final cameras = snapshot.data;

          if (cameras == null || cameras.isEmpty) {
            return const Icon(
              key: Key('animojiIntro_no_camera_icon'),
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

          context.read<CameraBloc>().add(CameraChanged(cameras[0]));

          return BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) => DropdownButton<CameraDescription>(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              value: state.camera,
              dropdownColor: HoloBoothColors.darkPurple,
              items: dropdownItems,
              onChanged: (value) =>
                  context.read<CameraBloc>().add(CameraChanged(value)),
            ),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is CameraException) {
            return CameraErrorView(
              key: const Key('animojiIntro_camera_error_view'),
              error: error,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: HoloBoothColors.white),
            );
          }
        }

        return const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: HoloBoothColors.convertLoading,
          ),
        );
      },
    );
  }
}
