import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareStatusListener extends StatelessWidget {
  const ShareStatusListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConvertBloc, ConvertState>(
      listenWhen: (previous, current) =>
          previous.shareStatus != current.shareStatus,
      listener: (context, state) {
        if (state.shareStatus == ShareStatus.success) {
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
      builder: (context, state) {
        if (state.shareStatus == ShareStatus.waiting) {
          return Container(
            color: Colors.black.withOpacity(0.2),
            alignment: Alignment.center,
            child: SizedBox.square(
                dimension: 50, child: CircularProgressIndicator()),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
