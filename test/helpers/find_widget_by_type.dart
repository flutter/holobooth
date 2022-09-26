// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension on `WidgetTester` which exposes a method to
/// find a widget by [Type].
extension FindWidgetByTypeExtension on WidgetTester {
  /// Returns a `Widget` of type `T`.
  T findWidgetByType<T extends Widget>() => widget<T>(find.byType(T));

  TextSpan textSpanContaining(String text) {
    final richTextFinder = find.textContaining(text, findRichText: true);
    final richText = widget<RichText>(richTextFinder);
    final textSpan = _findTextSpanContaining(richText, text);
    if (textSpan == null) {
      throw Exception('A TextSpan that contains $text has not been found');
    }
    return textSpan;
  }

  TextSpan? _findTextSpanContaining(RichText richText, String text) {
    TextSpan? textSpan;
    richText.text.visitChildren(
      (visitor) {
        if (visitor is TextSpan) {
          final visitorText = visitor.text;
          if (visitorText == null || !visitorText.contains(text)) return true;

          textSpan = visitor;
          return false;
        }
        return true;
      },
    );
    return textSpan;
  }

  void tapTextSpan(TextSpan textSpan) {
    (textSpan.recognizer as TapGestureRecognizer?)?.onTap?.call();
  }
}
