import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class ShareDialogCloseButton extends StatelessWidget {
  const ShareDialogCloseButton({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Assets.icons.closeIcon.image(height: size),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
