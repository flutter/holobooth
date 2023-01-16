import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

const landscapeDisplaySize = Size(1920, 1080);
const portraitDisplaySize = Size(1080, 1920);

extension HoloboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setLargeDisplaySize() {
    setDisplaySize(const Size(HoloboothBreakpoints.large, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(HoloboothBreakpoints.small - 1, 1000));
  }
}
