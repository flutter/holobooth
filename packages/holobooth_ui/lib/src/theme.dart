import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// Namespace for the Photobooth [ThemeData].
class PhotoboothTheme {
  /// Standard `ThemeData` for Photobooth UI.
  static ThemeData get standard {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(accentColor: HoloBoothColors.blue),
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonThemeData,
      textTheme: _textTheme,
      dialogBackgroundColor: HoloBoothColors.whiteBackground,
      dialogTheme: _dialogTheme,
      tooltipTheme: _tooltipTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      dividerTheme: _dividerTheme,
    );
  }

  /// `ThemeData` for Photobooth UI for small screens.
  static ThemeData get small {
    return standard.copyWith(textTheme: _smallTextTheme);
  }

  /// `ThemeData` for Photobooth UI for medium screens.
  static ThemeData get medium {
    return standard;
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headlineLarge: PhotoboothDesktopTextStyle.headlineLarge,
      headlineMedium: PhotoboothDesktopTextStyle.headlineMedium,
      headlineSmall: PhotoboothDesktopTextStyle.headlineSmall,
      titleSmall: PhotoboothDesktopTextStyle.titleSmall,
      bodyLarge: PhotoboothDesktopTextStyle.bodyLarge,
      bodyMedium: PhotoboothDesktopTextStyle.bodyMedium,
      bodySmall: PhotoboothDesktopTextStyle.bodySmall,
      labelLarge: PhotoboothDesktopTextStyle.labelLarge,
    );
  }

  static TextTheme get _smallTextTheme {
    return TextTheme(
      headlineLarge: PhotoboothMobileTextStyle.headlineLarge,
      headlineMedium: PhotoboothMobileTextStyle.headlineMedium,
      headlineSmall: PhotoboothMobileTextStyle.headlineSmall,
      titleSmall: PhotoboothMobileTextStyle.titleSmall,
      bodyLarge: PhotoboothMobileTextStyle.bodyLarge,
      bodyMedium: PhotoboothMobileTextStyle.bodyMedium,
      bodySmall: PhotoboothMobileTextStyle.bodySmall,
      labelLarge: PhotoboothMobileTextStyle.labelLarge,
    );
  }

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(color: HoloBoothColors.blue);
  }

  static TextButtonThemeData get _textButtonThemeData {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HoloBoothColors.white,
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: HoloBoothColors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(208, 54),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HoloBoothColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        side: const BorderSide(color: HoloBoothColors.white, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(208, 54),
      ),
    );
  }

  static TooltipThemeData get _tooltipTheme {
    return const TooltipThemeData(
      decoration: BoxDecoration(
        color: HoloBoothColors.charcoal,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.all(10),
      textStyle: TextStyle(color: HoloBoothColors.white),
    );
  }

  static DialogTheme get _dialogTheme {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: HoloBoothColors.whiteBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }

  static TabBarTheme get _tabBarTheme {
    return TabBarTheme(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        gradient: HoloBoothGradients.secondarySix,
      ),
      labelColor: HoloBoothColors.white,
      unselectedLabelColor: HoloBoothColors.gray,
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(color: HoloBoothColors.transparent);
  }
}
