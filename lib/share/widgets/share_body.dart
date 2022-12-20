import 'package:flutter/material.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({required this.images, super.key});

  final List<PhotoboothCameraImage> images;

  @override
  Widget build(BuildContext context) {
    final image = images.first;

    return Align(
      child: ResponsiveLayoutBuilder(
        small: (context, _) {
          return _SmallShareBody(image: image);
        },
        large: (context, _) {
          return _LargeShareBody(image: image);
        },
      ),
    );
  }
}

class _SmallShareBody extends StatelessWidget {
  const _SmallShareBody({required this.image});

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedPhotoboothPhoto(image: image),
        _ShareBodyContent(
          isSmallScreen: true,
        ),
      ],
    );
  }
}

class _LargeShareBody extends StatelessWidget {
  const _LargeShareBody({required this.image});

  final PhotoboothCameraImage image;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Row(
            children: [
              Expanded(child: AnimatedPhotoboothPhoto(image: image)),
              const Expanded(child: _ShareBodyContent(isSmallScreen: false))
            ],
          ),
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
          if (!isSmallScreen) const Spacer(),
          const ShareHeading(),
          const SizedBox(height: 32),
          const ShareSubheading(),
          const SizedBox(height: 54),
          _ShareBodyButtons(isSmallScreen: isSmallScreen),
          if (!isSmallScreen) const Spacer(),
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
        SizedBox(height: 12),
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
    const buttonHeight = 60.0;
    const buttonWidth = 200.0;
    const buttonSpacing = 24.0;
    return Wrap(
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: const [
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ShareButton(),
        ),
        SizedBox(width: buttonSpacing),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: DownloadButton(),
        ),
        SizedBox(width: buttonSpacing),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: RetakeButton(),
        ),
      ],
    );
  }
}
