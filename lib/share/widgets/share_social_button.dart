import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';

class SmallShareSocialButtons extends StatelessWidget {
  const SmallShareSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TwitterButton(),
        SizedBox(height: 16),
        FacebookButton(),
      ],
    );
  }
}

class LargeShareSocialButtons extends StatelessWidget {
  const LargeShareSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: TwitterButton()),
        SizedBox(width: 16),
        Expanded(child: FacebookButton()),
      ],
    );
  }
}
