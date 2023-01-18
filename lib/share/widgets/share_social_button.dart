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
    const buttonWidth = 200.0;
    const buttonSpacing = 24.0;
    return Wrap(
      runSpacing: 16,
      spacing: buttonSpacing,
      alignment: WrapAlignment.center,
      children: const [
        SizedBox(width: buttonWidth, child: TwitterButton()),
        SizedBox(width: buttonWidth, child: FacebookButton()),
      ],
    );
  }
}
