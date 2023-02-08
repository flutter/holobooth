import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareDialogCloseButton extends StatelessWidget {
  const ShareDialogCloseButton({
    required this.size,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: HoloBoothColors.transparent,
        child: InkWell(
          child: Assets.icons.closeIcon.image(height: size),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
