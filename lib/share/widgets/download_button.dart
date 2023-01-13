import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

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
          showAppDialog<void>(
            context: context,
            child: DownloadOptionDialog(layerLink: layerLink),
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
    return AlertDialog(
      shadowColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      backgroundColor: HoloBoothColors.transparent,
      content: CompositedTransformFollower(
        link: layerLink,
        offset: const Offset(0, 70),
        child: GradientFrame(
          height: 100,
          width: 100,
          borderRadius: 12,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  DownloadAsAGifButton(),
                  SizedBox(height: 16),
                  DownloadAsAVideoButton(),
                ],
              ),
            ),
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
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('GIF'),
    );
  }
}

class DownloadAsAVideoButton extends StatelessWidget {
  const DownloadAsAVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('VIDEO'),
    );
  }
}
