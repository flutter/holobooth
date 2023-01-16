import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

/// Displays a dialog above the current contents of the app.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) =>
    showDialog<T>(
      context: context,
      barrierColor: HoloBoothColors.charcoal,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
