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

    final state = context.watch<ConvertBloc>().state;
    final isLoading = state.shareStatus == ShareStatus.waiting &&
        state.shareType == ShareType.socialMedia;

    return GradientOutlinedButton(
      loading: isLoading,
      onPressed: () async {
        final convertStatus = context.read<ConvertBloc>().state.status;
        if (convertStatus == ConvertStatus.videoCreated) {
          await showAppDialog<void>(
            context: context,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ConvertBloc>()),
              ],
              child: const ShareDialog(),
            ),
          );
        } else {
          context
              .read<ConvertBloc>()
              .add(const ShareRequested(ShareType.socialMedia));
        }
      },
      icon: const Icon(
        Icons.share,
        color: HoloBoothColors.white,
      ),
      label: l10n.sharePageShareButtonText,
    );
  }
}
