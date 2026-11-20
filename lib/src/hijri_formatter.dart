import 'hijri_date.dart';

/// Language used for month and weekday names.
enum HijriLocale {
  /// Arabic names.
  ar,

  /// English transliterated names.
  en,
}

/// Numeral system used when formatting a date.
enum HijriDigits {
  /// ASCII digits `0..9`.
  western,

  /// Arabic-Indic digits `٠..٩`.
  arabic,
}

/// Formats a [HijriDate] with Arabic or English names and digits.
///
/// Supported tokens are `yyyy`, `yy`, `y`, `MMMM`, `MMM`, `MM`, `M`, `dd`,
/// `d`, `EEEE` and `EEE`.
///
/// ```dart
/// const formatter = HijriFormatter(
///   pattern: 'EEEE، d MMMM yyyy',
///   locale: HijriLocale.ar,
///   digits: HijriDigits.arabic,
/// );
/// print(formatter.format(HijriDate(1445, 1, 1)));
/// ```
class HijriFormatter {
  /// Creates a formatter with the given [pattern], [locale] and [digits].
  const HijriFormatter({
    this.pattern = 'dd/MM/yyyy',
    this.locale = HijriLocale.ar,
    this.digits = HijriDigits.arabic,
  });

  static const List<String> _arabicMonths = <String>[
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static const List<String> _englishMonths = <String>[
    'Muharram',
    'Safar',
    'Rabi al-Awwal',
    'Rabi al-Thani',
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ];

  static const List<String> _arabicShortMonths = <String>[
    'محرم',
    'صفر',
    'ربيع 1',
    'ربيع 2',
    'جمادى 1',
    'جمادى 2',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'القعدة',
    'الحجة',
  ];

  static const List<String> _englishShortMonths = <String>[
    'Muh',
    'Saf',
    'Rab I',
    'Rab II',
    'Jum I',
    'Jum II',
    'Raj',
    "Sha'",
    'Ram',
    'Shaw',
    "Dhu Q",
    'Dhu H',
  ];

  static const List<String> _arabicWeekdays = <String>[
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const List<String> _englishWeekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// The pattern used by [format].
  final String pattern;

  /// Language of month and weekday names.
  final HijriLocale locale;

  /// Numeral system of the formatted numbers.
  final HijriDigits digits;

  /// Name of Hijri [month] (1..12) in [locale].
  static String monthName(int month, {HijriLocale locale = HijriLocale.ar}) {
    final names = locale == HijriLocale.ar ? _arabicMonths : _englishMonths;
    return names[month - 1];
  }

  /// Short name of Hijri [month] (1..12) in [locale].
  static String shortMonthName(
    int month, {
    HijriLocale locale = HijriLocale.ar,
  }) {
    final names = locale == HijriLocale.ar
        ? _arabicShortMonths
        : _englishShortMonths;
    return names[month - 1];
  }

  /// Name of a [weekday] where 1 is Monday and 7 is Sunday.
  static String weekdayName(
    int weekday, {
    HijriLocale locale = HijriLocale.ar,
    bool short = false,
  }) {
    final names = locale == HijriLocale.ar ? _arabicWeekdays : _englishWeekdays;
    final name = names[weekday - 1];
    return short && locale == HijriLocale.en ? name.substring(0, 3) : name;
  }

  /// Formats [date] according to this formatter's settings.
  String format(HijriDate date) {
    final result = pattern.replaceAllMapped(
      RegExp(r'yyyy|yy|y|MMMM|MMM|MM|M|dd|d|EEEE|EEE'),
      (Match match) {
        switch (match.group(0)) {
          case 'yyyy':
            return _number(date.year, 4);
          case 'y':
            return _number(date.year, 1);
          case 'yy':
            return _number(date.year % 100, 2);
          case 'MMMM':
            return monthName(date.month, locale: locale);
          case 'MMM':
            return shortMonthName(date.month, locale: locale);
          case 'MM':
            return _number(date.month, 2);
          case 'M':
            return _number(date.month, 1);
          case 'dd':
            return _number(date.day, 2);
          case 'd':
            return _number(date.day, 1);
          case 'EEEE':
            return weekdayName(date.weekday, locale: locale);
          case 'EEE':
            return weekdayName(date.weekday, locale: locale, short: true);
          default:
            return match.group(0)!;
        }
      },
    );
    return result;
  }

  /// Returns a copy with the given parts replaced.
  HijriFormatter copyWith({
    String? pattern,
    HijriLocale? locale,
    HijriDigits? digits,
  }) {
    return HijriFormatter(
      pattern: pattern ?? this.pattern,
      locale: locale ?? this.locale,
      digits: digits ?? this.digits,
    );
  }

  String _number(int value, int width) {
    final padded = value.toString().padLeft(width, '0');
    if (digits == HijriDigits.western) {
      return padded;
    }
    const western = '0123456789';
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    return padded.split('').map((digit) {
      final index = western.indexOf(digit);
      return index == -1 ? digit : arabic[index];
    }).join();
  }

  @override
  String toString() =>
      'HijriFormatter(pattern: $pattern, locale: $locale, digits: $digits)';
}

/// Convenience formatting helpers for [HijriDate].
extension HijriDateFormatting on HijriDate {
  /// Formats this date with a one-off [pattern], [locale] and [digits].
  String format({
    String pattern = 'dd/MM/yyyy',
    HijriLocale locale = HijriLocale.ar,
    HijriDigits digits = HijriDigits.arabic,
  }) {
    return HijriFormatter(
      pattern: pattern,
      locale: locale,
      digits: digits,
    ).format(this);
  }
}
