import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class TwitterButton extends StatelessWidget {
  const TwitterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        final twitterShareUrl =
            context.read<ConvertBloc>().state.twitterShareUrl;

        openLink(twitterShareUrl);
        Navigator.of(context).pop();
      },
      label: l10n.shareDialogTwitterButtonText,
      icon: Assets.icons.twitterLogo.image(width: 24),
    );
  }
}
