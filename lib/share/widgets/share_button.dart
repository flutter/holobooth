import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.platformHelper,
    required this.image,
  });

  /// Optional [PlatformHelper] instance.
  ///
  /// Used to decide whether to show a [ShareBottomSheet] or [ShareDialog].
  final PlatformHelper? platformHelper;

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PhotoboothColors.white,
      ),
      onPressed: () async {
        await showAppModal<void>(
          context: context,
          platformHelper: platformHelper,
          portraitChild: BlocProvider.value(
            value: context.read<ShareBloc>(),
            child: ShareBottomSheet(image: image),
          ),
          landscapeChild: BlocProvider.value(
            value: context.read<ShareBloc>(),
            child: ShareDialog(
              image: image,
            ),
          ),
        );
      },
      child: Text(
        l10n.sharePageShareButtonText,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: PhotoboothColors.blue),
      ),
    );
  }
}
