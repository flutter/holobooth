import 'package:flutter/widgets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Photobooth test Style Definitions
class PhotoboothTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'photobooth_ui',
    fontFamily: 'GoogleSans',
    color: PhotoboothColors.black,
    fontWeight: PhotoboothFontWeight.regular,
  );

  /// Display large test Style
  static TextStyle get displayLarge {
    return _baseTextStyle.copyWith(
      fontSize: 56,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Display medium test Style
  static TextStyle get displayMedium {
    return _baseTextStyle.copyWith(
      fontSize: 30,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Display small test Style
  static TextStyle get displaySmall {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Headline medium test Style
  static TextStyle get headlineMedium {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Headline small test Style
  static TextStyle get headlineSmall {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Title large test Style
  static TextStyle get titleLarge {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Title medium test Style
  static TextStyle get titleMedium {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Title small text Style
  static TextStyle get titleSmall {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: PhotoboothFontWeight.bold,
    );
  }

  /// Body large text Style
  static TextStyle get bodyLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }

  /// Body medium text Style (the default)
  static TextStyle get bodyMedium {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Body small test Style
  static TextStyle get bodySmall {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label small test Style
  static TextStyle get labelSmall {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: PhotoboothFontWeight.regular,
    );
  }

  /// Label large test Style
  static TextStyle get labelLarge {
    return _baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: PhotoboothFontWeight.medium,
    );
  }
}
