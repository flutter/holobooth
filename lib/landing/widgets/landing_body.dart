import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/landing/landing.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({super.key});

  @visibleForTesting
  static const landingPageImageKey = Key('landingPage_image');

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, _) => const _SmallLandingBody(),
      large: (context, _) => const _LargeLandingBody(),
    );
  }
}

class _SmallLandingBody extends StatelessWidget {
  const _SmallLandingBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: const [
                SizedBox(height: 46),
                _LandingBodyContent(smallScreen: true),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Assets.backgrounds.holobooth.image(
                  key: LandingBody.landingPageImageKey,
                ),
              ),
              FullFooter(showIconsForSmall: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeLandingBody extends StatelessWidget {
  const _LargeLandingBody();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Assets.backgrounds.holobooth.image(
                      key: LandingBody.landingPageImageKey,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                const Expanded(
                  child: _LandingBodyContent(smallScreen: false),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: FullFooter(showIconsForSmall: false),
          ),
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
        GradientText(
          text: l10n.landingPageHeading,
          style: theme.textTheme.headlineLarge,
          textAlign: smallScreen ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),
        SelectableText(
          l10n.landingPageSubheading,
          key: const Key('landingPage_subheading_text'),
          style: theme.textTheme.titleSmall?.copyWith(
            color: HoloBoothColors.white,
          ),
          textAlign: smallScreen ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        const LandingTakePhotoButton(),
      ],
    );
  }
}
