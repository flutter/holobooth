import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      focusable: true,
      button: true,
      label: l10n.stickersNextButtonLabelText,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: const CircleBorder(),
        color: PhotoboothColors.transparent,
        child: InkWell(
          key: const Key('stickersPage_next_inkWell'),
          onTap: () {
            Navigator.of(context).push(PhotoBoothPage.route());
          },
          child: Assets.icons.goNextButtonIcon.image(height: 100),
        ),
      ),
    );
  }
}
