import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories/stories.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  final dashbook = Dashbook(theme: PhotoboothTheme.standard);

  addGradientButtonStories(dashbook);
  addGradientTextStory(dashbook);
  addHoloBoothAlertDialogStories(dashbook);

  runApp(dashbook);
}
