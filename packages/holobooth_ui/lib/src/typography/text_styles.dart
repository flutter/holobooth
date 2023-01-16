import 'package:flutter/widgets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// Holobooth text style definitions for larger devices.
class HoloboothDesktopTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'holobooth_ui',
    fontFamily: 'GoogleSans',
    color: HoloBoothColors.black,
    fontWeight: HoloboothFontWeight.regular,
  );

  /// Headline large text style
  static TextStyle get headlineLarge {
    return _baseTextStyle.copyWith(
      fontSize: 64,
      height: 1.25,
      fontWeight: HoloboothFontWeight.bold,
    );
  }

  /// Headline medium text style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 54,
      height: 16 / 13,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Headline small text style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 32,
      height: 1.25,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Title small text style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 4 / 3,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Body large text style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 4 / 3,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Body medium text style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      height: 10 / 7,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Body small text style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Label large text style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 20,
      height: 1.4,
      fontWeight: HoloboothFontWeight.medium,
    );
  }
}

/// Holobooth text style definitions for small devices.
class HoloboothMobileTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'holobooth_ui',
    fontFamily: 'GoogleSans',
    color: HoloBoothColors.black,
    fontWeight: HoloboothFontWeight.regular,
  );

  /// Headline large text style
  static TextStyle get headlineLarge {
    return _baseTextStyle.copyWith(
      fontSize: 34,
      height: 22 / 17,
      fontWeight: HoloboothFontWeight.bold,
    );
  }

  /// Headline medium text style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 34,
      height: 1,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Headline small text style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 4 / 3,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Title small text style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 4 / 3,
      fontWeight: HoloboothFontWeight.medium,
    );
  }

  /// Body large text style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      height: 1.5,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Body medium text style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Body small text style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: HoloboothFontWeight.regular,
    );
  }

  /// Label large text style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 14 / 9,
      fontWeight: HoloboothFontWeight.medium,
    );
  }
}
