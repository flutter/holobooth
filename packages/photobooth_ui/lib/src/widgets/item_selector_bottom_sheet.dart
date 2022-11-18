import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template item_selector_bottom_sheet}
/// Bottom sheet for selecting backgrounds or characters for mobile screens.
/// {@endtemplate}
class ItemSelectorBottomSheet<T> extends StatelessWidget {
  /// {@macro item_selector_bottom_sheet}
  const ItemSelectorBottomSheet({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.selectedItem,
    required this.onSelected,
    super.key,
  });

  /// The bottom sheet's title.
  final String title;

  /// The list of backgrounds or characters.
  final List<T> items;

  /// The widget that builds each displayed item.
  final Widget Function(BuildContext, T) itemBuilder;

  /// The selected item.
  final T? selectedItem;

  /// The functionality of the selected item.
  final ValueChanged<T> onSelected;

  /// The method to show the bottom sheet.
  static Future<void> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    required T? selectedItem,
    required ValueChanged<T> onSelected,
    Key? key,
  }) =>
      showBottomSheet<void>(
        backgroundColor: PhotoboothColors.black.withOpacity(.3),
        context: context,
        builder: (context) => ItemSelectorBottomSheet(
          title: title,
          items: items,
          itemBuilder: itemBuilder,
          selectedItem: selectedItem,
          onSelected: onSelected,
          key: key,
        ),
      ).closed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 64,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PhotoboothColors.white.withOpacity(.7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 24, color: PhotoboothColors.white),
                  ),
                  IconTheme.merge(
                    child: const CloseButton(color: PhotoboothColors.white),
                    data: const IconThemeData(size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    for (final item in items) ...[
                      GestureDetector(
                        onTap: () => onSelected(item),
                        child: Container(
                          width: 120,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: item == selectedItem
                                ? Border.all(
                                    color: PhotoboothColors.white,
                                    width: 4,
                                  )
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              item == selectedItem ? 16 : 20,
                            ),
                            child: itemBuilder(context, item),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
