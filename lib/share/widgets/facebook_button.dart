import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        final state = context.read<ShareBloc>().state;
        if (state.shareStatus.isSuccess &&
            state.shareUrl == ShareUrl.facebook) {
          Navigator.of(context).pop();
          openLink(state.facebookShareUrl);
          return;
        }
        context
            .read<ShareBloc>()
            .add(const ShareTapped(shareUrl: ShareUrl.facebook));

        Navigator.of(context).pop();
      },
      label: Text(l10n.shareDialogFacebookButtonText),
      icon: Icon(Icons.abc),
    );
  }
}
