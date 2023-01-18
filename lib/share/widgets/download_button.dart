import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/share/share.dart';
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
    final state = context.watch<DownloadBloc>().state;
    final isLoading = state.status == DownloadStatus.fetching;

    return CompositedTransformTarget(
      link: layerLink,
      child: GradientOutlinedButton(
        icon: isLoading
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: HoloBoothColors.convertLoading,
                ),
              )
            : const Icon(
                Icons.file_download_rounded,
                color: HoloBoothColors.white,
              ),
        label: l10n.sharePageDownloadButtonText,
        onPressed: isLoading
            ? null
            : () {
                final downloadBloc = context.read<DownloadBloc>();
                showDialog<void>(
                  context: context,
                  barrierColor: HoloBoothColors.transparent,
                  builder: (context) => BlocProvider.value(
                    value: downloadBloc,
                    child: DownloadOptionDialog(
                      layerLink: layerLink,
                    ),
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
  });

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
        trackEvent(
          category: 'button',
          action: 'click-download-gif',
          label: 'download-gif',
        );
        Navigator.of(context).pop();
        context.read<DownloadBloc>().add(const DownloadRequested.gif());
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
        trackEvent(
          category: 'button',
          action: 'click-download-video',
          label: 'download-video',
        );
        Navigator.of(context).pop();
        context.read<DownloadBloc>().add(const DownloadRequested.video());
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
