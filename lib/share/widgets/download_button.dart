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
            child: AlertDialog(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('GIF'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('VIDEO'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
