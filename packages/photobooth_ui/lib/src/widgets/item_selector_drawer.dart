import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/src/colors.dart';

/// {@template item_selector_drawer}
/// Drawer for selecting backgrounds or characters.
/// {@endtemplate}
class ItemSelectorDrawer<T> extends StatelessWidget {
  /// {@macro item_selector_drawer}
  const ItemSelectorDrawer({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.selectedItem,
    required this.onSelected,
    super.key,
  });

  /// The drawer's title.
  final String title;

  /// The list of backgrounds or characters.
  final List<T> items;

  /// The widget that builds each displayed item.
  final Widget Function(BuildContext, T) itemBuilder;

  /// The selected item.
  final T? selectedItem;

  /// The functionality of the selected item.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Drawer(
          backgroundColor: PhotoboothColors.black.withOpacity(.3),
          width: 336,
          child: ListView(
            padding: const EdgeInsets.all(48),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 32,
                            color: PhotoboothColors.white,
                          ),
                    ),
                  ),
                  IconTheme.merge(
                    child: const CloseButton(
                      color: PhotoboothColors.white,
                    ),
                    data: const IconThemeData(size: 40),
                  ),
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              for (final item in items) ...[
                GestureDetector(
                  onTap: () => onSelected(item),
                  child: Container(
                    width: 240,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: item == selectedItem
                          ? Border.all(color: PhotoboothColors.white, width: 8)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(item == selectedItem ? 22 : 30),
                      child: itemBuilder(context, item),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
