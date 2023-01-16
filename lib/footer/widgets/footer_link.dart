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
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: HoloBoothColors.white,
            ),
      ),
    );
  }
}

class FlutterForwardFooterLink extends StatelessWidget {
  const FlutterForwardFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: flutterForwardLink,
      text: l10n.flutterForwardLinkFooterText,
    );
  }
}

class HowItsMadeFooterLink extends StatelessWidget {
  const HowItsMadeFooterLink({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FooterLink(
      link: howItsMadeLink,
      text: l10n.footerHowItsMadeLinkText,
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
