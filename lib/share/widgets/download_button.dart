import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
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

  void _showDownloadOptionsDialog() {
    final downloadBloc = context.read<DownloadBloc>();
    final url = context.read<ConvertBloc>().state.videoPath;
    showDialog<void>(
      context: context,
      barrierColor: HoloBoothColors.transparent,
      builder: (context) => BlocProvider.value(
        value: downloadBloc,
        child: DownloadOptionDialog(
          layerLink: layerLink,
          url: url,
        ),
      ),
    );
  }

  void _showErrorView() {
    showAppDialog<void>(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ConvertBloc>()),
        ],
        child: const HoloBoothAlertDialog(
          height: 300,
          child: ConvertErrorView(
            convertErrorOrigin: ConvertErrorOrigin.video,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final downloadState = context.watch<DownloadBloc>().state;
    final convertState = context.watch<ConvertBloc>().state;
    final isLoading = (convertState.shareStatus == ShareStatus.waiting &&
            convertState.shareType == ShareType.download) ||
        downloadState.status == DownloadStatus.fetching;

    return BlocListener<ConvertBloc, ConvertState>(
      listenWhen: (previous, current) =>
          previous.shareStatus != current.shareStatus,
      listener: (context, state) {
        if (state.shareStatus == ShareStatus.ready &&
            state.shareType == ShareType.download) {
          _showDownloadOptionsDialog();
        }
      },
      child: CompositedTransformTarget(
        link: layerLink,
        child: GradientOutlinedButton(
          loading: isLoading,
          icon: const Icon(
            Icons.file_download_rounded,
            color: HoloBoothColors.white,
          ),
          label: l10n.sharePageDownloadButtonText,
          onPressed: () {
            final convertStatus = context.read<ConvertBloc>().state.status;
            if (convertStatus == ConvertStatus.videoCreated) {
              _showDownloadOptionsDialog();
            } else if (convertStatus == ConvertStatus.creatingVideo) {
              context
                  .read<ConvertBloc>()
                  .add(const ShareRequested(ShareType.download));
            } else if (convertStatus == ConvertStatus.errorGeneratingVideo) {
              _showErrorView();
            }
          },
        ),
      ),
    );
  }
}

class DownloadOptionDialog extends StatelessWidget {
  const DownloadOptionDialog({
    required this.layerLink,
    required this.url,
    super.key,
  });

  final LayerLink layerLink;
  final String url;

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
              DownloadAsAGifButton(
                url: url,
              ),
              DownloadAsAVideoButton(
                url: url,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadAsAGifButton extends StatelessWidget {
  const DownloadAsAGifButton({
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        context.read<DownloadBloc>().add(DownloadRequested.gif(url));
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
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        context.read<DownloadBloc>().add(DownloadRequested.video(url));
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
