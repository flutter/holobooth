import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({super.key, required this.firstFrame});

  final ByteData firstFrame;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SingleChildScrollView(
        child: ResponsiveLayoutBuilder(
          small: (context, _) => SmallShareBody(firstFrame),
          large: (context, _) => LargeShareBody(firstFrame),
        ),
      ),
    );
  }
}

@visibleForTesting
class SmallShareBody extends StatelessWidget {
  const SmallShareBody(this.firstFrame, {super.key});

  final ByteData firstFrame;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.memory(firstFrame.buffer.asUint8List()),
          const _ShareBodyContent(isSmallScreen: true),
        ],
      ),
    );
  }
}

@visibleForTesting
class LargeShareBody extends StatelessWidget {
  const LargeShareBody(this.firstFrame, {super.key});

  final ByteData firstFrame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Image.memory(firstFrame.buffer.asUint8List()),
            ),
            const Expanded(
              child: _ShareBodyContent(isSmallScreen: false),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShareBodyContent extends StatelessWidget {
  const _ShareBodyContent({required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment:
            isSmallScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
        crossAxisAlignment: isSmallScreen
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShareHeading(),
          const SizedBox(height: 32),
          const ShareSubheading(),
          const SizedBox(height: 54),
          _ShareBodyButtons(isSmallScreen: isSmallScreen),
        ],
      ),
    );
  }
}

class _ShareBodyButtons extends StatelessWidget {
  const _ShareBodyButtons({required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    if (isSmallScreen) return const _SmallShareBodyButtons();
    return const _LargeShareBodyButtons();
  }
}

class _SmallShareBodyButtons extends StatelessWidget {
  const _SmallShareBodyButtons();

  @override
  Widget build(BuildContext context) {
    const buttonHeight = 60.0;
    const buttonWidth = 250.0;
    const buttonSpacing = 24.0;
    return Column(
      children: const [
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ShareButton(),
        ),
        SizedBox(height: buttonSpacing),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: DownloadButton(),
        ),
        SizedBox(height: buttonSpacing),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: RetakeButton(),
        ),
      ],
    );
  }
}

class _LargeShareBodyButtons extends StatelessWidget {
  const _LargeShareBodyButtons();

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 200.0;
    const buttonSpacing = 24.0;
    return Wrap(
      runSpacing: 16,
      spacing: buttonSpacing,
      alignment: WrapAlignment.center,
      children: const [
        SizedBox(
          width: buttonWidth,
          child: ShareButton(),
        ),
        SizedBox(
          width: buttonWidth,
          child: DownloadButton(),
        ),
        SizedBox(
          width: buttonWidth,
          child: RetakeButton(),
        ),
      ],
    );
  }
}
