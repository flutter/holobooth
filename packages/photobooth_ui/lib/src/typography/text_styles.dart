import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Photobooth text style definitions
class PhotoboothTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'photobooth_ui',
    fontFamily: 'GoogleSans',
    color: HoloBoothColors.black,
    fontWeight: PhotoboothFontWeight.regular,
  );

  /// Display large text style
  static TextStyle get displayLarge {
    return _baseTextStyle.copyWith(
      fontSize: 56,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Display medium text style
  static TextStyle get displayMedium {
    return _baseTextStyle.copyWith(
      fontSize: 30,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Display small text style
  static TextStyle get displaySmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Headline medium text style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 54,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Headline small text style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Title large text style
  static TextStyle get titleLarge {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Title medium text style
  static TextStyle get titleMedium {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Title small text style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Body large text style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Body medium text style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body small text style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label small text style
  static TextStyle get labelSmall {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label large text style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 21,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }
}
