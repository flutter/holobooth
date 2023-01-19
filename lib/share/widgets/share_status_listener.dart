import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareStatusListener extends StatelessWidget {
  const ShareStatusListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertBloc, ConvertState>(
      listenWhen: (previous, current) =>
          previous.shareStatus != current.shareStatus,
      listener: (context, state) {
        if (state.shareStatus == ShareStatus.ready) {
          showAppDialog<void>(
            context: context,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ConvertBloc>()),
              ],
              child: const ShareDialog(),
            ),
          );
        }
      },
      child: child,
    );
  }
}
