import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/gen/gen.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class IconLink extends StatelessWidget {
  const IconLink({
    super.key,
    required this.icon,
    required this.link,
  });

  final Widget icon;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: () => openLink(link),
      child: SizedBox(height: 30, width: 30, child: icon),
    );
  }
}

class FlutterIconLink extends StatelessWidget {
  const FlutterIconLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.flutterIcon.image(),
      link: flutterDevExternalLink,
    );
  }
}

class FirebaseIconLink extends StatelessWidget {
  const FirebaseIconLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.firebaseIcon.image(),
      link: firebaseExternalLink,
    );
  }
}

class MadeWithIconLinks extends StatelessWidget {
  const MadeWithIconLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FlutterIconLink(),
        SizedBox(width: 8),
        FirebaseIconLink(),
      ],
    );
  }
}
