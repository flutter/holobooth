import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CameraErrorView extends StatelessWidget {
  const CameraErrorView({super.key, required this.error});

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return const CameraAccessDeniedErrorView();
      default:
        return const CameraNotFoundErrorView();
    }
  }
}

class CameraNotFoundErrorView extends StatelessWidget {
  const CameraNotFoundErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _CameraErrorViewContent(errorMessage: l10n.cameraNotFoundMessage);
  }
}

class CameraAccessDeniedErrorView extends StatelessWidget {
  const CameraAccessDeniedErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _CameraErrorViewContent(
      errorMessage: l10n.cameraAccessDeniedMessage,
    );
  }
}

class _CameraErrorViewContent extends StatelessWidget {
  const _CameraErrorViewContent({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      color: HoloBoothColors.blurryContainerColor,
      blur: 7.5,
      borderRadius: BorderRadius.circular(38),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.videocam_off,
            color: HoloBoothColors.white,
          ),
          const SizedBox(width: 12),
          Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: HoloBoothColors.white),
          ),
        ],
      ),
    );
  }
}
