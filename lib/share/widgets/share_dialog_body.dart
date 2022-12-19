import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialogBody extends StatelessWidget {
  const ShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const SmallShareDialogBody(),
      large: (_, __) => const LargeShareDialogBody(),
    );
  }
}

class SmallShareDialogBody extends StatelessWidget {
  const SmallShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 40, right: 48),
            child: ShareDialogCloseButton(),
          ),
        ),
        ShareDialogHeading(),
        SizedBox(height: 24),
        ShareDialogSubheading(),
        SmallShareSocialButtons(),
        ShareDialogAnimation(),
        SocialMediaShareClarificationNote()
      ],
    );
  }
}

class LargeShareDialogBody extends StatelessWidget {
  const LargeShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: ShareDialogAnimation(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, right: 48),
                    child: ShareDialogCloseButton(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShareDialogHeading(),
                        SizedBox(height: 24),
                        ShareDialogSubheading(),
                        SizedBox(height: 60),
                        Align(child: LargeShareSocialButtons()),
                        Spacer(),
                        SocialMediaShareClarificationNote(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
