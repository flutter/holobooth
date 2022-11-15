import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
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

class FlutterFooterLink extends StatelessWidget {
  const FlutterFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: flutterDevExternalLink,
      text: l10n.flutterLinkFooterText,
    );
  }
}

class FirebaseFooterLink extends StatelessWidget {
  const FirebaseFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: firebaseExternalLink,
      text: l10n.firebaseLinkFooterText,
    );
  }
}

class TensorFlowFooterLink extends StatelessWidget {
  const TensorFlowFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: tensorFlowLink,
      text: l10n.tensorflowLinkFooterText,
    );
  }
}

class MediapipeFooterLink extends StatelessWidget {
  const MediapipeFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: mediaPipeLink,
      text: l10n.mediaPipeLinkFooterText,
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
      link: termsOfServiceLink,
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
      link: privacyPolicyLink,
      text: l10n.footerPrivacyPolicyLinkText,
    );
  }
}
