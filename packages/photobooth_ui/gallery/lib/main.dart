import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories/gradient_buttons.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  final dashbook = Dashbook(theme: PhotoboothTheme.standard);

  addGradientButtonStories(dashbook);

  runApp(dashbook);
}
