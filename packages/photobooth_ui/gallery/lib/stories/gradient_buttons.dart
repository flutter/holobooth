import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Adds the GradientButton examples to the given [dashbook].
void addGradientButtonStories(Dashbook dashbook) {
  dashbook.storiesOf('GradientButtons').add(
        'default',
        (_) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientElevatedButton(
              child: const Text('Press me'),
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            Container(
              color: HoloBoothColors.black,
              padding: const EdgeInsets.all(20),
              child: GradientOutlinedButton(
                onPressed: () {},
                icon: const Icon(Icons.touch_app_rounded),
                label: 'Press me',
              ),
            )
          ],
        ),
      );
}
