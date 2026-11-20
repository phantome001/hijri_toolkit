import 'package:flutter/widgets.dart';

import '../hijri_date.dart';
import '../hijri_formatter.dart';

/// Displays a [HijriDate] with an optional [formatter].
///
/// ```dart
/// HijriText(
///   HijriDate(1445, 1, 1),
///   formatter: HijriFormatter(locale: HijriLocale.ar),
/// )
/// ```
class HijriText extends StatelessWidget {
  /// Creates a widget that formats and displays [date].
  const HijriText(
    this.date, {
    super.key,
    this.formatter = const HijriFormatter(),
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  });

  /// The Hijri date to display.
  final HijriDate date;

  /// Formatting options. Defaults to Arabic names with Arabic-Indic digits.
  final HijriFormatter formatter;

  /// Optional text style.
  final TextStyle? style;

  /// Optional text alignment.
  final TextAlign? textAlign;

  /// Optional text direction. Defaults to RTL for Arabic locales.
  final TextDirection? textDirection;

  /// Optional overflow behavior.
  final TextOverflow? overflow;

  /// Optional maximum number of lines.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final direction =
        textDirection ?? (formatter.locale == HijriLocale.ar
            ? TextDirection.rtl
            : TextDirection.ltr);
    return Text(
      formatter.format(date),
      style: style,
      textAlign: textAlign,
      textDirection: direction,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
