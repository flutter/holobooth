import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({super.key});

  @visibleForTesting
  static const landingPageImageKey = Key('landingPage_image');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final small = size.width <= PhotoboothBreakpoints.small;

    final content = _LandingBodyContent(
      smallScreen: small,
    );
    final image = Assets.backgrounds.holobooth.image();

    return small
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 54),
                  content,
                  const SizedBox(height: 54),
                  image,
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(child: image),
                Expanded(child: content),
              ],
            ),
          );
  }
}

class _LandingBodyContent extends StatelessWidget {
  const _LandingBodyContent({required this.smallScreen});

  final bool smallScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment:
          smallScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
      crossAxisAlignment:
          smallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Assets.images.flutterForwardLogo.image(width: 300),
        const SizedBox(height: 32),
        SelectableText(
          l10n.landingPageHeading,
          key: const Key('landingPage_heading_text'),
          style: theme.textTheme.displayLarge!.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: smallScreen ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),
        SelectableText(
          l10n.landingPageSubheading,
          key: const Key('landingPage_subheading_text'),
          style: theme.textTheme.displaySmall!.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: smallScreen ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        const LandingTakePhotoButton(),
      ],
    );
  }
}
