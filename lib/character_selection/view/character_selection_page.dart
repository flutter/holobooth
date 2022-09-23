import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PhotoboothBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              PreviewTabs(name: Text('Character 1')),
              PreviewTabs(name: Text('Character 2')),
              PreviewTabs(name: Text('Character 3')),
              PreviewTabs(name: Text('Character 4')),
            ],
          )
        ],
      ),
    );
  }
}

class PreviewTabs extends StatelessWidget {
  const PreviewTabs({super.key, required this.name});

  final Text name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: name,
    );
  }
}
