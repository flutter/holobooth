import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Adds the GradientText example to the given [dashbook].
void addGradientTextStory(Dashbook dashbook) {
  dashbook.storiesOf('GradientText').add(
        'default',
        (_) => Center(
          child: Builder(
            builder: (context) {
              return GradientText(
                text: 'Gradient Text',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
        ),
      );
}
