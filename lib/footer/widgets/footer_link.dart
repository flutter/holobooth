import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class FooterLink extends StatelessWidget {
  const FooterLink({
    super.key,
    required this.text,
    required this.link,
  });

  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: () => openLink(link),
      child: Text(text),
    );
  }
}

class FooterFlutter extends StatelessWidget {
  const FooterFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://flutter.dev',
      text: l10n.footerMadeWithFlutterLinkText,
    );
  }
}

class FooterFirebase extends StatelessWidget {
  const FooterFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://firebase.google.com',
      text: l10n.footerMadeWithFirebaseLinkText,
    );
  }
}

class FooterTensorFlow extends StatelessWidget {
  const FooterTensorFlow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://www.tensorflow.org',
      text: l10n.footerTensorFlowLinkText,
    );
  }
}

class FooterMediaPipe extends StatelessWidget {
  const FooterMediaPipe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://google.github.io/mediapipe',
      text: l10n.footerMediaPipeLinkText,
    );
  }
}

class FooterTermsOfServiceLink extends StatelessWidget {
  const FooterTermsOfServiceLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://policies.google.com/terms',
      text: l10n.footerTermsOfServiceLinkText,
    );
  }
}

class FooterPrivacyPolicyLink extends StatelessWidget {
  const FooterPrivacyPolicyLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: 'https://policies.google.com/privacy',
      text: l10n.footerPrivacyPolicyLinkText,
    );
  }
}
