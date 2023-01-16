import 'package:flutter/material.dart';
import 'package:holobooth/share/share.dart';

class SmallShareSocialButtons extends StatelessWidget {
  const SmallShareSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: const [
          TwitterButton(),
          SizedBox(height: 24),
          FacebookButton(),
        ],
      ),
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
