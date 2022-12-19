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
      ),
    );
  }
}

class LargeShareDialogBody extends StatelessWidget {
  const LargeShareDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: ShareDialogAnimation(),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, right: 48),
                        child: ShareDialogCloseButton(),
                      ),
                    ),
                    ShareDialogHeading(),
                    SizedBox(height: 24),
                    ShareDialogSubheading(),
                    SizedBox(height: 60),
                    Align(child: LargeShareSocialButtons()),
                    SocialMediaShareClarificationNote(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
