enum Background { space, beach }

extension BackgroundX on Background {
  double toDouble() {
    switch (this) {
      case Background.space:
        return 1;
      case Background.beach:
        return 2;
    }
  }
}
