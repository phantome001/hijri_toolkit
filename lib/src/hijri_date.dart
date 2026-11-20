import 'package:flutter/foundation.dart';

/// Julian day number of 1 Muharram 1 AH in the proleptic Gregorian calendar.
const int _islamicEpochJdn = 1948439;

/// An immutable date in the tabular civil Hijri calendar.
///
/// The tabular civil calendar follows a fixed 30-year cycle. It is deterministic
/// and never depends on moon sighting, so it can differ by one day from
/// observation-based calendars such as Umm al-Qura.
///
/// ```dart
/// final hijri = HijriDate.fromDateTime(DateTime(2023, 7, 18));
/// print(hijri); // HijriDate(1445-1-1)
/// print(hijri.toDateTime()); // 2023-07-18 00:00:00.000
/// ```
@immutable
class HijriDate implements Comparable<HijriDate> {
  /// Creates a Hijri date from its [year], [month] and [day].
  const HijriDate(this.year, this.month, this.day)
    : assert(year >= 1, 'A Hijri year must be at least 1'),
      assert(month >= 1 && month <= 12, 'A Hijri month must be 1..12'),
      assert(day >= 1 && day <= 30, 'A Hijri day must be 1..30');

  /// The Hijri year.
  final int year;

  /// The Hijri month, where 1 is Muharram and 12 is Dhu al-Hijjah.
  final int month;

  /// The day of the Hijri month.
  final int day;

  /// Converts a Gregorian [date] into the tabular civil Hijri calendar.
  factory HijriDate.fromDateTime(DateTime date) {
    return _fromJdn(_julianDayNumber(date.year, date.month, date.day));
  }

  /// Creates a Hijri date for the current Gregorian day.
  factory HijriDate.now() => HijriDate.fromDateTime(DateTime.now());

  static int _leapsThrough(int year) => (11 * year + 14) ~/ 30;

  static int _daysBeforeYear(int year) =>
      354 * (year - 1) + _leapsThrough(year - 1);

  static int _daysBeforeMonth(int year, int month) {
    var total = 0;
    for (var m = 1; m < month; m++) {
      total += daysInMonth(year, m);
    }
    return total;
  }

  static int _julianDayNumber(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static DateTime _dateTimeFromJdn(int jdn) {
    final a = jdn + 32044;
    final b = (4 * a + 3) ~/ 146097;
    final c = a - (146097 * b) ~/ 4;
    final d = (4 * c + 3) ~/ 1461;
    final e = c - (1461 * d) ~/ 4;
    final m = (5 * e + 2) ~/ 153;
    final day = e - (153 * m + 2) ~/ 5 + 1;
    final month = m + 3 - 12 * (m ~/ 10);
    final year = 100 * b + d - 4800 + (m ~/ 10);
    return DateTime(year, month, day);
  }

  static HijriDate _fromJdn(int jdn) {
    final elapsed = jdn - _islamicEpochJdn;
    var year = (elapsed / 354.37).floor() + 1;
    if (year < 1) {
      year = 1;
    }
    while (_daysBeforeYear(year) > elapsed) {
      year--;
    }
    while (_daysBeforeYear(year + 1) <= elapsed) {
      year++;
    }

    var remaining = elapsed - _daysBeforeYear(year) + 1;
    var month = 1;
    while (month < 12) {
      final length = daysInMonth(year, month);
      if (remaining <= length) {
        break;
      }
      remaining -= length;
      month++;
    }
    return HijriDate(year, month, remaining);
  }

  int get _jdn =>
      _islamicEpochJdn +
      _daysBeforeYear(year) +
      _daysBeforeMonth(year, month) +
      day -
      1;

  /// Whether [year] is a leap year in the 30-year tabular cycle.
  static bool isLeapYear(int year) => _leapsThrough(year) > _leapsThrough(year - 1);

  /// Number of days in [month] of [year].
  static int daysInMonth(int year, int month) {
    assert(month >= 1 && month <= 12, 'A Hijri month must be 1..12');
    if (month.isOdd) {
      return 30;
    }
    if (month == 12 && isLeapYear(year)) {
      return 30;
    }
    return 29;
  }

  /// Number of days in [year].
  static int daysInYear(int year) => 354 + (isLeapYear(year) ? 1 : 0);

  /// Whether this date falls in a leap Hijri year.
  bool get inLeapYear => HijriDate.isLeapYear(year);

  /// Number of days in this date's month.
  int get monthLength => HijriDate.daysInMonth(year, month);

  /// Number of days in this date's year.
  int get yearLength => HijriDate.daysInYear(year);

  /// Weekday as an integer where 1 is Monday and 7 is Sunday.
  int get weekday => (_jdn % 7) + 1;

  /// Converts this Hijri date into a Gregorian [DateTime] at midnight.
  DateTime toDateTime() => _dateTimeFromJdn(_jdn);

  /// Returns a date [days] after this one, or before it when [days] is negative.
  HijriDate addDays(int days) => _fromJdn(_jdn + days);

  /// Number of whole days between this date and [other].
  int differenceInDays(HijriDate other) => _jdn - other._jdn;

  /// Returns a copy with the given parts replaced.
  HijriDate copyWith({int? year, int? month, int? day}) =>
      HijriDate(year ?? this.year, month ?? this.month, day ?? this.day);

  @override
  int compareTo(HijriDate other) => _jdn.compareTo(other._jdn);

  @override
  bool operator ==(Object other) =>
      other is HijriDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'HijriDate($year-$month-$day)';
}
