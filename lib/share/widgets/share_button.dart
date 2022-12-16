import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.image,
  });

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PhotoboothColors.white,
      ),
      onPressed: () {
        showAppDialog<void>(
          context: context,
          child: BlocProvider.value(
            value: context.read<ShareBloc>(),
            child: const ShareDialog(),
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
