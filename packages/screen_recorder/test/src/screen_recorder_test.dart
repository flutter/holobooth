// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_recorder/screen_recorder.dart';

void main() {
  group('ScreenRecorder', () {
    test('can be instantiated', () {
      expect(
        ScreenRecorder(
          height: 100,
          width: 100,
          controller: ScreenRecorderController(),
          child: SizedBox.shrink(),
        ),
        isNotNull,
      );
    });
  });
}
