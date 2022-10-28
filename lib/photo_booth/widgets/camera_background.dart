import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class CameraBackground extends StatelessWidget {
  const CameraBackground({
    super.key,
    required this.aspectRatio,
    required this.child,
  });

  final double aspectRatio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PhotoboothBackground(),
        BlocSelector<PhotoBoothBloc, PhotoBoothState, int>(
          selector: (state) => state.remainingPhotos,
          builder: (context, remainingPhotos) => Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Remaining photos: $remainingPhotos',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ColoredBox(
              color: PhotoboothColors.black,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
