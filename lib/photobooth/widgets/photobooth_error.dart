import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({super.key, required this.error});

  final CameraException error;

  @visibleForTesting
  static const cameraAccessDeniedKey =
      Key('photoboothError_cameraAccessDenied');

  @visibleForTesting
  static const cameraNotFoundKey = Key('photoboothError_cameraNotFound');

  @visibleForTesting
  static const cameraNotSupportedKey =
      Key('photoboothError_cameraNotSupported');

  @visibleForTesting
  static const unknownErrorKey = Key('photoboothError_unknown');

  @override
  Widget build(BuildContext context) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return const _PhotoboothCameraAccessDeniedError(
          key: cameraAccessDeniedKey,
        );
      case 'cameraNotFound':
        return const _PhotoboothCameraNotFoundError(
          key: cameraNotFoundKey,
        );
      case 'cameraNotSupported':
        return const _PhotoboothCameraNotSupportedError(
          key: cameraNotSupportedKey,
        );
      default:
        return const _PhotoboothCameraUnknownError(key: unknownErrorKey);
    }
  }
}

class _PhotoboothCameraAccessDeniedError extends StatelessWidget {
  const _PhotoboothCameraAccessDeniedError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
      children: [
        SelectableText(
          l10n.photoBoothCameraAccessDeniedHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraAccessDeniedSubheadline,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraNotFoundError extends StatelessWidget {
  const _PhotoboothCameraNotFoundError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
      children: [
        SelectableText(
          l10n.photoBoothCameraNotFoundHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotFoundSubheadline1,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotFoundSubheadline2,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraUnknownError extends StatelessWidget {
  const _PhotoboothCameraUnknownError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
      children: [
        SelectableText(
          l10n.photoBoothCameraErrorHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraErrorSubheadline1,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraErrorSubheadline2,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraNotSupportedError extends StatelessWidget {
  const _PhotoboothCameraNotSupportedError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
      children: [
        SelectableText(
          l10n.photoBoothCameraNotSupportedHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotSupportedSubheadline,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothErrorContent extends StatelessWidget {
  const _PhotoboothErrorContent({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
