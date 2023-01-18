import 'package:flutter/widgets.dart';

/// Defines the color palette for the Holobooth UI.
abstract class HoloBoothColors {
  /// Black
  static const Color black = Color(0xFF202124);

  /// Black 20% opacity
  static const Color black20 = Color(0x40202124);

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

  /// Orange
  static const Color orange = Color(0xFFFFBB00);

  /// Charcoal
  static const Color charcoal = Color(0xBF202124);

  /// Purple
  static const Color purple = Color(0xFF4100E0);

  /// Light purple
  static const Color lightPurple = Color(0xFF9455D9);

  /// Lighter purple
  static const Color lighterPurple = Color(0xFF9E81EF);

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

  /// Color for prop tab
  static const Color propTabSelection = Color(0xffB7F7CC);

  /// Color for convert loading animation.
  static const Color convertLoading = Color(0xFFe196d8);

  /// Color used as the background of the avatar animation.
  static const Color holoboothAvatarBackground = Color(0xFF030524);

  /// Color used for modal surfaces.
  static const Color modalSurface = Color(0xF2020320);

  /// Background color
  static const Color background = Color(0xFF12152B);

  /// Transparent scrim color
  static const Color scrim = Color(0x8513162C);

  /// Color used for blurry containers.
  static const Color blurrySurface = Color.fromRGBO(19, 22, 44, 0.75);

  /// Dusk color.
  static const Color dusk = Color(0xff676AB6);

  /// Background color for the video player progress bar.
  static const Color progressBarBackground = Color(0xFF1E1E1E);

  /// Color for the video player progress bar.
  static const Color progressBarColor = Color(0xFF27F5DD);

  /// Color for the video player close button.
  static final Color closeIcon = const Color(0xFF040522).withOpacity(.56);
}

/// Defines the gradients for the Holobooth UI.
class HoloBoothGradients {
  /// Primary One gradient
  static const Gradient primaryOne = LinearGradient(
    colors: <Color>[
      HoloBoothColors.purple,
      _gradientPink,
    ],
  );

  /// Primary Two gradient
  static const Gradient primaryTwo = LinearGradient(
    colors: <Color>[
      _gradientLightBlue,
      _gradientTeal,
    ],
  );

  /// Primary Three gradient
  static const Gradient primaryThree = LinearGradient(
    colors: <Color>[
      _gradientLightBlue,
      HoloBoothColors.purple,
    ],
  );

  /// Secondary One gradient
  static const Gradient secondaryOne = LinearGradient(
    colors: <Color>[
      _gradientYellow,
      _gradientTeal,
    ],
  );

  /// Secondary Two gradient
  static const Gradient secondaryTwo = LinearGradient(
    colors: <Color>[
      HoloBoothColors.lighterPurple,
      Color(0xFF52B8F7),
    ],
  );

  /// Secondary Three gradient
  static const Gradient secondaryThree = LinearGradient(
    colors: <Color>[
      _gradientYellow,
      HoloBoothColors.lighterPurple,
    ],
  );

  /// Secondary Four gradient
  static const Gradient secondaryFour = LinearGradient(
    colors: <Color>[
      _gradientPink,
      HoloBoothColors.lighterPurple,
    ],
  );

  /// Secondary Five gradient
  static const Gradient secondaryFive = LinearGradient(
    colors: <Color>[
      _gradientTeal,
      HoloBoothColors.lighterPurple,
    ],
  );

  /// Secondary Six gradient
  static const Gradient secondarySix = LinearGradient(
    colors: <Color>[
      HoloBoothColors.lighterPurple,
      HoloBoothColors.purple,
    ],
  );

  /// Props gradient
  static const Gradient props = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color.fromRGBO(44, 44, 44, 0.33),
      Color.fromRGBO(134, 134, 134, 0.4),
    ],
  );

  /// Button gradient
  static const Gradient button = LinearGradient(
    colors: <Color>[
      HoloBoothColors.purple,
      _gradientPink,
    ],
  );

  /// Button Border gradient
  static const Gradient buttonBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: <Color>[
      _gradientPink,
      HoloBoothColors.purple,
    ],
  );

  static const _gradientPink = Color(0xFFF8BBD0);

  static const _gradientLightBlue = Color(0xFF027DFD);

  static const _gradientTeal = Color(0xFF27F5DD);

  static const _gradientYellow = Color(0xffF9F8C4);
}
