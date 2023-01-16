// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('HoloboothTheme themeData', () {
    test('is defined for both small, medium, and standard', () {
      expect(HoloboothTheme.small, isA<ThemeData>());
      expect(HoloboothTheme.medium, isA<ThemeData>());
      expect(HoloboothTheme.standard, isA<ThemeData>());
    });
  });
}
