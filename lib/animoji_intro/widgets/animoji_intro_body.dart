import 'package:flutter/material.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class AnimojiIntroBody extends StatelessWidget {
  const AnimojiIntroBody({
    super.key,
    required this.onNextPressed,
  });

  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final small = size.width <= PhotoboothBreakpoints.small;

    return Align(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 32,
          ),
          constraints: const BoxConstraints(
            maxHeight: 600,
            minHeight: 515,
            maxWidth: 900,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: HoloBoothGradients.secondarySix,
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: small ? 1 : 2,
                        child: const ColoredBox(
                          color: HoloBoothColors.holoboothAvatarBackground,
                          child: Center(
                            child: FittedBox(
                              child: SizedBox(
                                width: 960,
                                height: 450,
                                child: AnimatedSprite(
                                  showLoadingIndicator: false,
                                  sprites: Sprites(
                                    asset: 'holobooth_avatar.png',
                                    size: Size(960, 450),
                                    frames: 45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Expanded(
                        child: _BottomContent(
                          smallScreen: small,
                          onNextPressed: onNextPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomContent extends StatelessWidget {
  const _BottomContent({
    required this.smallScreen,
    required this.onNextPressed,
  });

  final bool smallScreen;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: HoloBoothColors.modalSurface,
      padding: const EdgeInsets.all(20),
      child: Flex(
        direction: smallScreen ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return HoloBoothGradients.secondaryFive
                    .createShader(Offset.zero & bounds.size);
              },
              child: const Icon(
                Icons.videocam_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            flex: smallScreen ? 0 : 3,
            child: SelectableText(
              l10n.animojiIntroPageSubheading,
              key: const Key('animojiIntro_subheading_text'),
              style: textTheme.bodyLarge?.copyWith(
                color: HoloBoothColors.white,
              ),
              textAlign: smallScreen ? TextAlign.center : TextAlign.left,
            ),
          ),
          if (smallScreen) const SizedBox(height: 16),
          Flexible(
            child: NextButton(
              onNextPressed: onNextPressed,
            ),
          ),
        ],
      ),
    );
  }
}
