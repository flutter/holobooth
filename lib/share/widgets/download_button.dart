import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

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
          final convertBloc = context.read<ConvertBloc>();
          showDialog<void>(
            context: context,
            barrierColor: HoloBoothColors.transparent,
            builder: (context) => DownloadOptionDialog(
              layerLink: layerLink,
              download: convertBloc.download,
            ),
          );
        },
      ),
    );
  }
}

class DownloadOptionDialog extends StatelessWidget {
  const DownloadOptionDialog({
    super.key,
    required this.layerLink,
    required this.download,
  });

  final LayerLink layerLink;
  final void Function(String) download;

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
            children: [
              DownloadAsAGifButton(download: download),
              DownloadAsAVideoButton(download: download),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadAsAGifButton extends StatelessWidget {
  const DownloadAsAGifButton({
    super.key,
    required this.download,
  });
  final void Function(String) download;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        download('gif');
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
  const DownloadAsAVideoButton({
    super.key,
    required this.download,
  });
  final void Function(String) download;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        download('mp4');
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
