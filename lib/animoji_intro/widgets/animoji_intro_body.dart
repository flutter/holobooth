import 'package:flutter/material.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimojiIntroBody extends StatelessWidget {
  const AnimojiIntroBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final small = size.width <= PhotoboothBreakpoints.small;

    return Center(
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
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF9E81EF),
                  Color(0xFF4100E0),
                ],
              ),
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
                      // TODO(willhlas): add animation.
                      child: Container(
                        color: const Color(0xFF020320).withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Expanded(
                      child: _BottomContent(
                        smallScreen: small,
                      ),
                    ),
                  ],
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
  });

  final bool smallScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: const Color(0xFF020320).withOpacity(0.95),
      padding: const EdgeInsets.all(20),
      child: Flex(
        direction: smallScreen ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: <Color>[
                    Color(0xFF74F1DD),
                    Color(0xFF9E81EF),
                  ],
                ).createShader(Offset.zero & bounds.size);
              },
              child: const Icon(
                Icons.videocam_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            flex: smallScreen ? 1 : 3,
            child: SelectableText(
              l10n.animojiIntroPageSubheading,
              key: const Key('animojiIntro_subheading_text'),
              style: textTheme.displaySmall!.copyWith(
                color: PhotoboothColors.white,
              ),
              textAlign: smallScreen ? TextAlign.center : TextAlign.left,
            ),
          ),
          Flexible(
            child: NextButton(
              onNextPressed: () {
                Navigator.of(context).push(PhotoBoothPage.route());
              },
            ),
          ),
        ],
      ),
    );
  }
}
