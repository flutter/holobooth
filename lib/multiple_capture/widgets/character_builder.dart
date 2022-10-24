import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/avatar_animation/widgets/dash.dart';

class CharacterBuilder extends StatelessWidget {
  const CharacterBuilder({super.key, required this.avatar});

  final Avatar avatar;

  @override
  Widget build(BuildContext context) {
    return Center(child: Dash(avatar: avatar));
  }
}
