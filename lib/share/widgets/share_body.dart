import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SingleChildScrollView(
        child: ResponsiveLayoutBuilder(
          small: (context, _) => const SmallShareBody(),
          large: (context, _) => const LargeShareBody(),
        ),
      ),
    );
  }
}

@visibleForTesting
class SmallShareBody extends StatelessWidget {
  const SmallShareBody({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ConvertBloc>().state.firstFrameProcessed;
    return Column(
      children: [
        if (thumbnail != null)
          SizedBox(
            height: 450,
            child: PortalAnimation(
              mode: PortalMode.portrait,
              imageBytes: thumbnail.buffer.asUint8List(),
              onComplete: () {},
            ),
          ),
        const SizedBox(height: 48),
        const _ShareBodyContent(isSmallScreen: true),
      ],
    );
  }
}

@visibleForTesting
class LargeShareBody extends StatelessWidget {
  const LargeShareBody({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ConvertBloc>().state.firstFrameProcessed;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: thumbnail != null
                  ? SizedBox(
                      width: 450,
                      height: 450,
                      child: Align(
                        child: _PortalAnimation(thumbnail: thumbnail),
                      ),
                    )
                  : const SizedBox(),
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

class _PortalAnimation extends StatefulWidget {
  const _PortalAnimation({
    required this.thumbnail,
  });

  final Uint8List thumbnail;

  @override
  State<_PortalAnimation> createState() => _PortalAnimationState();
}

class _PortalAnimationState extends State<_PortalAnimation> {
  var _completed = false;
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final animation = PortalAnimation(
      key: _key,
      mode: PortalMode.landscape,
      imageBytes: widget.thumbnail.buffer.asUint8List(),
      onComplete: () {
        setState(() {
          _completed = true;
        });
      },
    );

    return _completed
        ? Clickable(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) {
                  // TODO check if it is loading.
                  final videoPath = context.read<ConvertBloc>().state.videoPath;
                  return VideoDialog(videoPath: videoPath);
                },
              );
            },
            child: animation,
          )
        : animation;
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
    const buttonWidth = 250.0;
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
