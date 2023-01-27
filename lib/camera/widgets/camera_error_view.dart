import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class CameraErrorView extends StatelessWidget {
  const CameraErrorView({super.key, required this.error, this.textStyle});

  final CameraException error;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final largeTextStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: HoloBoothColors.white);
    switch (error.code) {
      case 'CameraAccessDenied':
        return CameraAccessDeniedErrorView(
          textStyle: textStyle ?? largeTextStyle,
        );
      default:
        return CameraNotFoundErrorView(
          textStyle: textStyle ?? largeTextStyle,
        );
    }
  }
}

class CameraNotFoundErrorView extends StatelessWidget {
  const CameraNotFoundErrorView({super.key, required this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _CameraErrorViewContent(
      errorMessage: l10n.cameraNotFoundMessage,
      textStyle: textStyle,
    );
  }
}

class CameraAccessDeniedErrorView extends StatelessWidget {
  const CameraAccessDeniedErrorView({super.key, required this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _CameraErrorViewContent(
      errorMessage: l10n.cameraAccessDeniedMessage,
      textStyle: textStyle,
    );
  }
}

class _CameraErrorViewContent extends StatelessWidget {
  const _CameraErrorViewContent({
    required this.errorMessage,
    required this.textStyle,
  });

  final String errorMessage;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      color: HoloBoothColors.blurrySurface,
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
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
