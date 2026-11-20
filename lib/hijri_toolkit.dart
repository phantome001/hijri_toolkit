/// Convert between Gregorian and Hijri dates and format them in Arabic or
/// English.
///
/// Pure Dart and Flutter, with no dependencies and no platform plugins.
///
/// ```dart
/// import 'package:hijri_toolkit/hijri_toolkit.dart';
///
/// final hijri = HijriDate.fromDateTime(DateTime(2023, 7, 18));
/// print(hijri); // HijriDate(1445-1-1)
///
/// final formatter = HijriFormatter(
///   pattern: 'EEEE، d MMMM yyyy',
///   locale: HijriLocale.ar,
///   digits: HijriDigits.arabic,
/// );
/// print(formatter.format(hijri)); // الثلاثاء، ١ محرم ١٤٤٥
/// ```
library;

export 'src/hijri_date.dart';
export 'src/hijri_formatter.dart';
export 'src/widgets/hijri_text.dart';
