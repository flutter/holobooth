import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GradientOutlinedButton(
      onPressed: () async {
        await showAppDialog<void>(
          context: context,
          child: BlocProvider.value(
            value: context.read<ShareBloc>(),
            child: const ShareDialog(),
          ),
        );
      },
      icon: const Icon(
        Icons.share,
        color: HoloBoothColors.white,
      ),
      label: l10n.sharePageShareButtonText,
    );
  }
}
