import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// Namespace for the Holobooth [ThemeData].
class HoloboothTheme {
  /// Standard `ThemeData` for Holobooth UI.
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

  /// `ThemeData` for Holobooth UI for small screens.
  static ThemeData get small {
    return standard.copyWith(textTheme: _smallTextTheme);
  }

  /// `ThemeData` for Holobooth UI for medium screens.
  static ThemeData get medium {
    return standard;
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headlineLarge: HoloboothDesktopTextStyle.headlineLarge,
      headlineMedium: HoloboothDesktopTextStyle.headlineMedium,
      headlineSmall: HoloboothDesktopTextStyle.headlineSmall,
      titleSmall: HoloboothDesktopTextStyle.titleSmall,
      bodyLarge: HoloboothDesktopTextStyle.bodyLarge,
      bodyMedium: HoloboothDesktopTextStyle.bodyMedium,
      bodySmall: HoloboothDesktopTextStyle.bodySmall,
      labelLarge: HoloboothDesktopTextStyle.labelLarge,
    );
  }

  static TextTheme get _smallTextTheme {
    return TextTheme(
      headlineLarge: HoloboothMobileTextStyle.headlineLarge,
      headlineMedium: HoloboothMobileTextStyle.headlineMedium,
      headlineSmall: HoloboothMobileTextStyle.headlineSmall,
      titleSmall: HoloboothMobileTextStyle.titleSmall,
      bodyLarge: HoloboothMobileTextStyle.bodyLarge,
      bodyMedium: HoloboothMobileTextStyle.bodyMedium,
      bodySmall: HoloboothMobileTextStyle.bodySmall,
      labelLarge: HoloboothMobileTextStyle.labelLarge,
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
