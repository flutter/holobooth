import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// Adds the GradientText example to the given [dashbook].
void addHoloBoothAlertDialogStories(Dashbook dashbook) {
  dashbook.storiesOf('HoloBoothAlertDialog').add(
        'default',
        (_) => Center(
          child: Builder(
            builder: (context) {
              return const HoloBoothAlertDialog(
                height: 300,
                width: 300,
                child: SizedBox(),
              );
            },
          ),
        ),
      );
}
