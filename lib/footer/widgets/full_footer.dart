import 'package:flutter/material.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/widgets/widgets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class FullFooter extends StatelessWidget {
  FullFooter({
    super.key,
    this.showIconsForSmall = true,
    PlatformHelper? platformHelper,
  }) : _platformHelper = platformHelper ?? PlatformHelper();

  final bool showIconsForSmall;
  final PlatformHelper _platformHelper;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 32);
    const icons = [
      FlutterIconLink(),
      FirebaseIconLink(),
      TensorflowIconLink(),
      MediapipeIconLink(),
    ];

    return SizedBox(
      height: 100,
      child: ResponsiveLayoutBuilder(
        small: (context, child) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
            ).copyWith(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              decoration: showIconsForSmall
                  ? null
                  : BoxDecoration(
                      color: HoloBoothColors.scrim,
                      borderRadius: BorderRadius.circular(16),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showIconsForSmall)
                    for (final icon in icons) ...[
                      icon,
                      if (icon != icons.last) gap,
                    ]
                  else ...[
                    if (child != null) Flexible(child: child),
                    if (!_platformHelper.isMobile) ...[
                      gap,
                      const MuteButton(),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
        large: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 24,
            ),
            child: Row(
              children: [
                for (final icon in icons) ...[
                  icon,
                  gap,
                ],
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: child,
                  ),
                ),
                if (!_platformHelper.isMobile) ...[
                  gap,
                  const MuteButton(),
                ],
              ],
            ),
          );
        },
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: const [
            FlutterForwardFooterLink(),
            gap,
            HowItsMadeFooterLink(),
            gap,
            FooterTermsOfServiceLink(),
            gap,
            FooterPrivacyPolicyLink(),
          ],
        ),
      ),
    );
  }
}
