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
          height: 40,
          width: 100,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? HoloBoothColors.white
                  : HoloBoothColors.transparent,
            ),
            gradient: HoloBoothGradients.props,
          ),
          child: Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: HoloBoothColors.white),
          ),
        ),
      ),
    );
  }
}
