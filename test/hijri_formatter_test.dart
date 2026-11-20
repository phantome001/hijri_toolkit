import 'package:flutter_test/flutter_test.dart';
import 'package:hijri_toolkit/hijri_toolkit.dart';

void main() {
  const date = HijriDate(1445, 1, 1);

  group('HijriFormatter digits', () {
    test('formats Arabic-Indic digits by default', () {
      const formatter = HijriFormatter(pattern: 'dd/MM/yyyy');
      expect(formatter.format(date), '٠١/٠١/١٤٤٥');
    });

    test('formats Western digits when requested', () {
      const formatter = HijriFormatter(
        pattern: 'dd/MM/yyyy',
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), '01/01/1445');
    });

    test('pads numeric tokens', () {
      const formatter = HijriFormatter(
        pattern: 'y-M-d yy MM dd',
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), '1445-1-1 45 01 01');
    });
  });

  group('HijriFormatter names', () {
    test('formats Arabic month names', () {
      const formatter = HijriFormatter(
        pattern: 'd MMMM yyyy',
        locale: HijriLocale.ar,
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), '1 محرم 1445');
    });

    test('formats English month names', () {
      const formatter = HijriFormatter(
        pattern: 'd MMMM yyyy',
        locale: HijriLocale.en,
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), '1 Muharram 1445');
    });

    test('formats short month names', () {
      const formatter = HijriFormatter(
        pattern: 'd MMM yyyy',
        locale: HijriLocale.en,
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), '1 Muh 1445');
    });

    test('formats weekday names', () {
      const formatter = HijriFormatter(
        pattern: 'EEEE، d MMMM yyyy',
        locale: HijriLocale.ar,
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), 'الثلاثاء، 1 محرم 1445');
    });

    test('formats short weekday names', () {
      const formatter = HijriFormatter(
        pattern: 'EEE d MMM yyyy',
        locale: HijriLocale.en,
        digits: HijriDigits.western,
      );
      expect(formatter.format(date), 'Tue 1 Muh 1445');
    });

    test('monthName and shortMonthName cover all 12 months', () {
      for (var month = 1; month <= 12; month++) {
        expect(HijriFormatter.monthName(month), isNotEmpty);
        expect(HijriFormatter.shortMonthName(month), isNotEmpty);
        expect(
          HijriFormatter.monthName(month, locale: HijriLocale.en),
          isNotEmpty,
        );
      }
    });
  });

  group('HijriFormatter helpers', () {
    test('extension format matches formatter', () {
      expect(
        date.format(digits: HijriDigits.western),
        const HijriFormatter(digits: HijriDigits.western).format(date),
      );
    });

    test('copyWith replaces only the given parts', () {
      const formatter = HijriFormatter();
      final updated = formatter.copyWith(locale: HijriLocale.en);
      expect(updated.locale, HijriLocale.en);
      expect(updated.pattern, formatter.pattern);
      expect(updated.digits, formatter.digits);
    });

    test('toString describes the formatter', () {
      expect(
        const HijriFormatter().toString(),
        contains('HijriFormatter('),
      );
    });
  });
}
