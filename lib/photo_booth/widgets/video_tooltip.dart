import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class VideoTooltip extends StatelessWidget {
  const VideoTooltip({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(32, 33, 36, 0.75),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: PhotoboothColors.white,
            ),
      ),
    );
  }
}
