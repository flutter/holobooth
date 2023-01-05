import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LoadingFramesView extends StatelessWidget {
  const LoadingFramesView({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Loading...',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: PhotoboothColors.white),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xffF9F8C4),
                Color(0xff27F5DD),
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Container(
            height: 35,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(200)),
              border: Border.all(color: Colors.white),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(200)),
              child: LinearProgressIndicator(
                value: progress,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
                backgroundColor: PhotoboothColors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
