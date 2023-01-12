import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Photobooth text style definitions for larger devices.
class PhotoboothDesktopTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'photobooth_ui',
    fontFamily: 'GoogleSans',
    color: HoloBoothColors.black,
    fontWeight: PhotoboothFontWeight.regular,
  );

  /// Headline large text style
  static TextStyle get headlineLarge {
    return _baseTextStyle.copyWith(
      fontSize: 64,
      height: 1.25,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Headline medium text style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 54,
      height: 16 / 13,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Headline small text style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 32,
      height: 1.25,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Title small text style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 4 / 3,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Body large text style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 4 / 3,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body medium text style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      height: 10 / 7,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body small text style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label large text style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 20,
      height: 1.4,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }
}

/// Photobooth text style definitions for small devices.
class PhotoboothMobileTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'photobooth_ui',
    fontFamily: 'GoogleSans',
    color: HoloBoothColors.black,
    fontWeight: PhotoboothFontWeight.regular,
  );

  /// Headline large text style
  static TextStyle get headlineLarge {
    return _baseTextStyle.copyWith(
      fontSize: 34,
      height: 22 / 17,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Headline medium text style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 34,
      height: 1,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Headline small text style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 4 / 3,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Title small text style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 4 / 3,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Body large text style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      height: 1.5,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body medium text style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body small text style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 5 / 3,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label large text style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      height: 14 / 9,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }
}
