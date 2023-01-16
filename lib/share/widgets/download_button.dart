import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({super.key});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CompositedTransformTarget(
      link: layerLink,
      child: GradientOutlinedButton(
        icon: const Icon(
          Icons.file_download_rounded,
          color: HoloBoothColors.white,
        ),
        label: l10n.sharePageDownloadButtonText,
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierColor: HoloBoothColors.transparent,
            builder: (context) => DownloadOptionDialog(layerLink: layerLink),
          );
        },
      ),
    );
  }
}

class DownloadOptionDialog extends StatelessWidget {
  const DownloadOptionDialog({super.key, required this.layerLink});

  final LayerLink layerLink;
  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: layerLink,
      offset: const Offset(0, 70),
      child: Align(
        alignment: Alignment.topLeft,
        child: GradientFrame(
          width: 200,
          borderRadius: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: const [
              DownloadAsAGifButton(),
              DownloadAsAVideoButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadAsAGifButton extends StatelessWidget {
  const DownloadAsAGifButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: ShaderMask(
        shaderCallback: (bounds) {
          return HoloBoothGradients.secondaryFour
              .createShader(Offset.zero & bounds.size);
        },
        child: const Icon(Icons.download),
      ),
      label: Text(
        context.l10n.downloadOptionGif,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
      ),
    );
  }
}

class DownloadAsAVideoButton extends StatelessWidget {
  const DownloadAsAVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: ShaderMask(
        shaderCallback: (bounds) {
          return HoloBoothGradients.secondaryFour
              .createShader(Offset.zero & bounds.size);
        },
        child: const Icon(Icons.download),
      ),
      label: Text(
        context.l10n.downloadOptionVideo,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
      ),
    );
  }
}
