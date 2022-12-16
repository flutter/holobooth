import 'package:flutter/material.dart';
import 'package:io_photobooth/share/widgets/widgets.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      constraints: const BoxConstraints(
        maxHeight: 2000,
        minHeight: 1000,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF9E81EF),
            Color(0xFF4100E0),
          ],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF020320).withOpacity(0.95),
          borderRadius: BorderRadius.circular(38),
        ),
        child: const ShareDialogBody(),
      ),
    );
  }
}
