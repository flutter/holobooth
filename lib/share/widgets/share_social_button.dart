import 'package:flutter/material.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class SmallShareSocialButtons extends StatelessWidget {
  const SmallShareSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 80),
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
