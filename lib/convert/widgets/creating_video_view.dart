import 'package:flutter/material.dart';
import 'package:io_photobooth/convert/convert.dart';

class CreatingVideoView extends StatelessWidget {
  const CreatingVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ConvertLoadingAnimation(dimension: 200),
        SizedBox(height: 50),
        ConvertMessage(),
      ],
    );
  }
}
