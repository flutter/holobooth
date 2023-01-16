import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class TwitterButton extends StatelessWidget {
  const TwitterButton({
    super.key,
    this.sharingEnabled = const bool.fromEnvironment(
      'SHARING_ENABLED',
    ),
  });

  final bool sharingEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientOutlinedButton(
      onPressed: () {
        if (sharingEnabled) {
          final twitterShareUrl =
              context.read<ConvertBloc>().state.twitterShareUrl;

          openLink(twitterShareUrl);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.sharingDisabled)));
        }
        Navigator.of(context).pop();
      },
      label: l10n.shareDialogTwitterButtonText,
      icon: Assets.icons.twitterLogo.image(width: 24),
    );
  }
}
