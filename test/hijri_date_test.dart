import 'package:flutter_test/flutter_test.dart';
import 'package:hijri_toolkit/hijri_toolkit.dart';

void main() {
  group('HijriDate conversion', () {
    test('converts the Islamic epoch', () {
      final hijri = HijriDate.fromDateTime(DateTime(622, 7, 18));
      expect(hijri.year, 1);
      expect(hijri.month, 1);
      expect(hijri.day, 1);
    });

    test('converts 2023-07-18 to 1 Muharram 1445', () {
      final hijri = HijriDate.fromDateTime(DateTime(2023, 7, 18));
      expect(hijri, HijriDate(1445, 1, 1));
    });

    test('converts 1 Muharram 1445 back to 2023-07-18', () {
      final gregorian = HijriDate(1445, 1, 1).toDateTime();
      expect(gregorian.year, 2023);
      expect(gregorian.month, 7);
      expect(gregorian.day, 18);
    });

    test('round-trips a range of Gregorian dates', () {
      for (var day = 0; day < 1000; day++) {
        final gregorian = DateTime(2020, 1, 1).add(Duration(days: day * 7));
        final hijri = HijriDate.fromDateTime(gregorian);
        final back = hijri.toDateTime();
        expect(
          DateTime(back.year, back.month, back.day),
          DateTime(gregorian.year, gregorian.month, gregorian.day),
          reason: 'Failed for $gregorian -> $hijri',
        );
      }
    });

    test('round-trips a range of Hijri dates', () {
      for (var day = 0; day < 1000; day++) {
        final hijri = HijriDate(1400, 1, 1).addDays(day * 7);
        final gregorian = hijri.toDateTime();
        final back = HijriDate.fromDateTime(gregorian);
        expect(back, hijri, reason: 'Failed for $hijri -> $gregorian');
      }
    });
  });

  group('HijriDate arithmetic', () {
    test('addDays crosses month boundaries', () {
      final date = HijriDate(1445, 1, 30);
      expect(date.addDays(1), HijriDate(1445, 2, 1));
    });

    test('addDays supports negative values', () {
      final date = HijriDate(1445, 2, 1);
      expect(date.addDays(-1), HijriDate(1445, 1, 30));
    });

    test('differenceInDays is symmetric', () {
      final a = HijriDate(1445, 1, 1);
      final b = a.addDays(45);
      expect(b.differenceInDays(a), 45);
      expect(a.differenceInDays(b), -45);
    });

    test('compareTo orders dates', () {
      final a = HijriDate(1445, 1, 1);
      final b = HijriDate(1445, 1, 2);
      final c = HijriDate(1445, 2, 1);
      expect(a.compareTo(b), lessThan(0));
      expect(b.compareTo(c), lessThan(0));
      expect(c.compareTo(a), greaterThan(0));
    });

    test('copyWith replaces only the given parts', () {
      final date = HijriDate(1445, 1, 1);
      expect(date.copyWith(day: 5), HijriDate(1445, 1, 5));
      expect(date.copyWith(year: 1446, month: 2), HijriDate(1446, 2, 1));
    });

    test('weekday uses 1 for Monday and 7 for Sunday', () {
      // 2023-07-17 was a Monday and 2023-07-23 was a Sunday.
      expect(HijriDate.fromDateTime(DateTime(2023, 7, 17)).weekday, 1);
      expect(HijriDate.fromDateTime(DateTime(2023, 7, 23)).weekday, 7);
    });
  });

  group('HijriDate calendar rules', () {
    test('odd months have 30 days', () {
      for (final month in [1, 3, 5, 7, 9, 11]) {
        expect(HijriDate.daysInMonth(1445, month), 30);
      }
    });

    test('even months have 29 days except leap year month 12', () {
      for (final month in [2, 4, 6, 8, 10]) {
        expect(HijriDate.daysInMonth(1445, month), 29);
      }
      expect(HijriDate.daysInMonth(1445, 12), 30);
      expect(HijriDate.daysInMonth(1444, 12), 29);
    });

    test('leap years follow the 30-year cycle', () {
      final leapYears = <int>[];
      for (var year = 1440; year < 1470; year++) {
        if (HijriDate.isLeapYear(year)) {
          leapYears.add(year);
        }
      }
      expect(leapYears, [
        1442,
        1445,
        1447,
        1450,
        1453,
        1456,
        1458,
        1461,
        1464,
        1466,
        1469,
      ]);
    });

    test('daysInYear matches leap status', () {
      expect(HijriDate.daysInYear(1445), 355);
      expect(HijriDate.daysInYear(1444), 354);
    });

    test('equality and hashCode', () {
      final a = HijriDate(1445, 1, 1);
      final b = HijriDate(1445, 1, 1);
      final c = HijriDate(1445, 1, 2);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });
}
