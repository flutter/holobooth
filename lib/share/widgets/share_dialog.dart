import 'package:flutter/material.dart';
import 'package:io_photobooth/share/widgets/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: PhotoboothColors.transparent,
      content: Container(
        padding: const EdgeInsets.all(1),
        height: isSmall ? 900 : 600,
        width: isSmall ? 500 : 900,
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
      ),
    );
  }
}
