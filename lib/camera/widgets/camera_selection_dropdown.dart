import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/camera/camera.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class CameraSelectionDropdown extends StatelessWidget {
  const CameraSelectionDropdown({super.key});

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
          return _CameraErrorView(
            key: cameraErrorViewKey,
            error: state.cameraError!,
          );
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
          return _CameraErrorView(
            key: cameraErrorViewKey,
            error: CameraException('cameraNotFound', 'Camera not found'),
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

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    const color = HoloBoothColors.red;
    final l10n = context.l10n;

    var errorMessage = l10n.unknownCameraErrorMessage;
    if (error is CameraException) {
      final cameraException = error as CameraException;
      switch (cameraException.code) {
        case 'CameraAccessDenied':
          errorMessage = l10n.cameraAccessDeniedMessage;
          break;
        default:
          errorMessage = l10n.cameraNotFoundMessage;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.videocam_off,
          color: color,
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            errorMessage,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
