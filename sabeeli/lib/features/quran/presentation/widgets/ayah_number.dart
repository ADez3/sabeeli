import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/arabic_numerals.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/numerals.dart';

/// The end-of-ayah marker in the user's digits.
///
/// With Arabic-Indic digits the Quran font draws its own ornament: a no-break space
/// followed by the number is ligated into the numbered circle. The font has no such
/// ligature for Western or Persian digits, so those are set between ornate
/// parentheses instead. It stays plain text on purpose: inline widgets inside
/// right-to-left paragraphs can be laid out in the wrong order.
InlineSpan ayahNumberSpan(
  BuildContext context, {
  required int ayah,
  required TextStyle style,
  Color? color,
  Color? background,
  GestureRecognizer? recognizer,
}) {
  final numerals = context.numerals;
  final number = numerals == Numerals.arabicIndic
      ? toArabicIndic(ayah)
      : '﴿${numerals.apply('$ayah')}﴾';
  return TextSpan(
    text: ' $number ',
    recognizer: recognizer,
    style: style.copyWith(color: color, backgroundColor: background),
  );
}
