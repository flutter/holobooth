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
    return SingleChildScrollView(
      child: Column(
        children: const [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 18, right: 18),
              child: ShareDialogCloseButton(size: 40),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: ShareDialogHeading(),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ShareDialogSubheading(),
          ),
          SizedBox(height: 24),
          SmallShareSocialButtons(),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShareDialogAnimation(),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 24),
            child: SocialMediaShareClarificationNote(),
          )
        ],
      ),
    );
  }
}

class LargeShareDialogBody extends StatelessWidget {
  const LargeShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: ShareDialog.largeShareDialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: ShareDialogAnimation(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 40, right: 48, bottom: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: ShareDialogCloseButton(
                              size: 48,
                            ),
                          ),
                          ShareDialogHeading(),
                          SizedBox(height: 24),
                          ShareDialogSubheading(),
                          SizedBox(height: 40),
                          LargeShareSocialButtons(),
                          Spacer(),
                          SocialMediaShareClarificationNote(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ],
    );
  }
}
