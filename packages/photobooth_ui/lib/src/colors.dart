import 'package:flutter/widgets.dart';

/// Defines the color palette for the Photobooth UI.
abstract class PhotoboothColors {
  /// Black
  static const Color black = Color(0xFF202124);

  /// Black 54% opacity
  static const Color black54 = Color(0x8A000000);

  /// Black 25% opacity
  static const Color black25 = Color(0x40202124);

  /// Black 20% opacity
  static const Color black20 = Color(0x40202124);

  /// Gray
  static const Color gray = Color(0xFFCFCFCF);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// WhiteBackground
  static const Color whiteBackground = Color(0xFFE8EAED);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// Blue
  static const Color blue = Color(0xFF428EFF);

  /// Red
  static const Color red = Color(0xFFFB5246);

  /// Green
  static const Color green = Color(0xFF3fBC5C);

  /// Orange
  static const Color orange = Color(0xFFFFBB00);

  /// Charcoal
  static const Color charcoal = Color(0xBF202124);

  /// Purple
  static const Color purple = Color(0xFFBB42F4);
}

/// Defines the color palette for the Holobooth UI.
abstract class HoloBoothColors {
  /// Purple
  static const Color purple = Color(0xFF4100E0);

  /// Light purple
  static const Color lightPurple = Color(0xFF9455D9);

  /// Dark purple
  static const Color darkPurple = Color(0xFF20225A);

  /// Dark blue
  static const Color darkBlue = Color(0xFF061A4A);

  /// Sparky color
  static const Color sparkyColor = Color.fromRGBO(238, 87, 66, 1);

  /// Dark blue
  static const Color gray = Color(0xff7A7C93);

  /// Light grey
  static const Color lightGrey = Color(0xffC0C0C0);

  /// First color of gradient secondary
  static const Color gradientSecondaryOne = Color(0xffF9F8C4);

  /// Second color of gradient secondary
  static const Color gradientSecondaryTwo = Color(0xff27F5DD);

  /// Color for prop tab
  static const Color propTabSelection = Color(0xffB7F7CC);

  /// Color for secondary two start
  static const Color secondaryTwoStart = Color(0xff9E81EF);

  /// Color for gradient secondary four start.
  static const Color gradientSecondaryFourStart = Color(0xffF8BBD0);

  /// Color for gradient secondary four stop.
  static const Color gradientSecondaryFourStop = Color(0xff9E81EF);

  /// Color for gradient secondary three start.
  static const Color gradientSecondaryThreeStart = Color(0xffF9F7C9);

  /// Color for gradient secondary three stop.
  static const Color gradientSecondaryThreeStop = Color(0xff9E81EF);
}
