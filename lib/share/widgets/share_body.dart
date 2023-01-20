import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareBody extends StatelessWidget {
  ShareBody({
    super.key,
    PlatformHelper? platformHelper,
  }) : _platformHelper = platformHelper ?? PlatformHelper();

  final PlatformHelper _platformHelper;

  @visibleForTesting
  static const portalVideoButtonKey = Key(
    'portal_video_button_key',
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = _platformHelper.isMobile;
    return Align(
      child: SingleChildScrollView(
        child: ResponsiveLayoutBuilder(
          small: (context, _) => SmallShareBody(isMobile: isMobile),
          large: (context, _) => LargeShareBody(isMobile: isMobile),
        ),
      ),
    );
  }
}

@visibleForTesting
class SmallShareBody extends StatelessWidget {
  const SmallShareBody({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ConvertBloc>().state.firstFrameProcessed;
    return Column(
      children: [
        if (thumbnail != null && !isMobile)
          SizedBox(
            height: 450,
            child: PortalAnimationView(
              thumbnail: thumbnail,
              mode: PortalMode.portrait,
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
  const LargeShareBody({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ConvertBloc>().state.firstFrameProcessed;

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: thumbnail != null && !isMobile
                ? SizedBox(
                    width: 450,
                    height: 450,
                    child: Align(
                      child: PortalAnimationView(
                        thumbnail: thumbnail,
                        mode: PortalMode.landscape,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          const Expanded(
            child: _ShareBodyContent(isSmallScreen: false),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class PortalAnimationView extends StatefulWidget {
  const PortalAnimationView({
    super.key,
    required this.thumbnail,
    required this.mode,
  });

  final Uint8List thumbnail;
  final PortalMode mode;

  @override
  State<PortalAnimationView> createState() => _PortalAnimationViewState();
}

class _PortalAnimationViewState extends State<PortalAnimationView> {
  var _completed = false;
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final animation = PortalAnimation(
      key: _key,
      mode: widget.mode,
      imageBytes: widget.thumbnail.buffer.asUint8List(),
      onComplete: () {
        setState(() {
          _completed = true;
        });
      },
    );

    return _completed
        ? Clickable(
            key: ShareBody.portalVideoButtonKey,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) {
                  final convertBloc = context.read<ConvertBloc>();
                  return VideoDialogLauncher(convertBloc: convertBloc);
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
    const buttonWidth = 250.0;
    const buttonSpacing = 24.0;
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: buttonWidth),
          child: const ShareButton(),
        ),
        const SizedBox(height: buttonSpacing),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: buttonWidth),
          child: const DownloadButton(),
        ),
        const SizedBox(height: buttonSpacing),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: buttonWidth),
          child: const RetakeButton(),
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
