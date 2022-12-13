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
    final image = Assets.backgrounds.holobooth.image(
      key: landingPageImageKey,
    );

    return Align(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ResponsiveLayoutBuilder(
          small: (context, _) {
            return Column(
              children: [
                const SizedBox(height: 54),
                const _LandingBodyContent(smallScreen: true),
                const SizedBox(height: 54),
                image,
              ],
            );
          },
          large: (context, _) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: image),
                    const Expanded(
                      child: _LandingBodyContent(smallScreen: false),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
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
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                // TODO(willhlas): use theme colors once it's ready.
                Color(0xFFEFBDCF),
                Color(0xFF9E81EF),
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: SelectableText(
            l10n.landingPageHeading,
            key: const Key('landingPage_heading_text'),
            style: theme.textTheme.displayLarge!.copyWith(
              color: PhotoboothColors.white,
            ),
            textAlign: smallScreen ? TextAlign.center : TextAlign.left,
          ),
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
