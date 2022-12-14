import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PropSelectionElement extends StatelessWidget {
  const PropSelectionElement({
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focusable: true,
      button: true,
      label: name,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 75,
          width: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? PhotoboothColors.white
                  : PhotoboothColors.transparent,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF2C2C2C).withOpacity(0.3),
                const Color(0xFF868686).withOpacity(0.4),
              ],
            ),
          ),
          child: Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ),
      ),
    );
  }
}
