import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialogBody extends StatelessWidget {
  const ShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const SmallShareDialogBody(),
      large: (_, __) => const LargeShareDialogBody(),
    );
  }
}

class SmallShareDialogBody extends StatelessWidget {
  const SmallShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LargeShareDialogBody extends StatelessWidget {
  const LargeShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(24),
          child: ShareDialogAnimation(),
        )),
        Expanded(
          child: Column(
            
            children: [
              ShareDialogCloseButton(),
              ShareDialogHeading(),
              ShareDialogSubheading(),
            ],
          ),
        )
      ],
    );
  }
}
