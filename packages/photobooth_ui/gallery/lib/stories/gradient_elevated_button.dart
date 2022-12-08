import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void addGradientElevatedButtonStories(Dashbook dashbook) {
  dashbook.storiesOf('GradientElevatedButton').add(
        'default',
        (_) => Center(
           child: GradientElevatedButton(
            child: const Text('Press me'),
            onPressed: () {},
          )
        ),
      );
}
