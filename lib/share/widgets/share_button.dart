import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GradientOutlinedButton(
      onPressed: () async {
        await showAppDialog<void>(
          context: context,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ShareBloc>()),
              BlocProvider.value(value: context.read<ConvertBloc>()),
            ],
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
