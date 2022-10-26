import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/widgets/icon_link.dart';

class CharacterSelectionFooter extends StatelessWidget {
  const CharacterSelectionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, bottom: 48),
      child: Row(
        children: const [
          FlutterIconLink(),
          SizedBox(width: 22),
          FirebaseIconLink(),
          SizedBox(width: 22),
          TensorflowIconLink()
        ],
      ),
    );
  }
}
