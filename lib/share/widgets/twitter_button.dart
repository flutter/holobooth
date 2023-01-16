import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class TwitterButton extends StatelessWidget {
  const TwitterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        final state = context.read<ShareBloc>().state;
        if (state.shareStatus.isSuccess && state.shareUrl == ShareUrl.twitter) {
          Navigator.of(context).pop();
          openLink(state.twitterShareUrl);
          return;
        }

        context
            .read<ShareBloc>()
            .add(const ShareTapped(shareUrl: ShareUrl.twitter));

        Navigator.of(context).pop();
      },
      label: l10n.shareDialogTwitterButtonText,
      icon: Assets.icons.twitterLogo.image(width: 24),
    );
  }
}
