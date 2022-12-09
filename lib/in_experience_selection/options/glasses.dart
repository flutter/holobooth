enum Glasses {
  none,
  glasses1,
}

extension GlassesX on Glasses {
  double toDouble() {
    switch (this) {
      case Glasses.none:
        return 0;
      case Glasses.glasses1:
        return 2;
    }
  }
}
