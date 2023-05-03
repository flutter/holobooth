import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/external_links/external_links.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class IconLink extends StatelessWidget {
  const IconLink({
    required this.icon,
    required this.link,
    super.key,
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
  const FlutterIconLink({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.flutterIcon.image(),
      link: flutterDevExternalLink,
    );
  }
}

class FirebaseIconLink extends StatelessWidget {
  const FirebaseIconLink({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.firebaseIcon.image(),
      link: firebaseExternalLink,
    );
  }
}

class TensorflowIconLink extends StatelessWidget {
  const TensorflowIconLink({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.tensorflowIcon.image(),
      link: tensorFlowLink,
    );
  }
}

class MediapipeIconLink extends StatelessWidget {
  const MediapipeIconLink({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Assets.icons.mediapipeIcon.image(),
      link: mediaPipeLink,
    );
  }
}
