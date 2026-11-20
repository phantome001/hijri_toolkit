# hijri_toolkit

[![pub package](https://img.shields.io/pub/v/hijri_toolkit.svg)](https://pub.dev/packages/hijri_toolkit)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Convert between Gregorian and Hijri dates and format them in Arabic or English.
Pure Dart and Flutter — no dependencies, no native code, no platform plugins.

## Features

- Convert `DateTime` ↔ `HijriDate` using the deterministic tabular civil
  Hijri calendar (30-year cycle).
- Arabic month and weekday names, plus English transliterations.
- Arabic-Indic (`٠١٢٣٤٥٦٧٨٩`) or Western (`0..9`) digits.
- Pattern-based formatting (`yyyy`, `MMMM`, `EEEE`, …).
- Date arithmetic (`addDays`, `differenceInDays`, `copyWith`).
- A small `HijriText` widget with automatic RTL for Arabic.

## Usage

```dart
import 'package:hijri_toolkit/hijri_toolkit.dart';

final hijri = HijriDate.fromDateTime(DateTime(2023, 7, 18));
print(hijri); // HijriDate(1445-1-1)

final gregorian = HijriDate(1445, 1, 1).toDateTime();
print(gregorian); // 2023-07-18 00:00:00.000

final formatter = HijriFormatter(
  pattern: 'EEEE، d MMMM yyyy',
  locale: HijriLocale.ar,
  digits: HijriDigits.arabic,
);
print(formatter.format(hijri)); // الثلاثاء، ١ محرم ١٤٤٥
```

In a widget tree:

```dart
HijriText(
  HijriDate.now(),
  formatter: HijriFormatter(pattern: 'd MMMM yyyy'),
)
```

## Accuracy note

This package implements the **tabular civil** Hijri calendar, which is based
on a fixed arithmetic cycle. It does not use moon sighting, so dates can differ
by one day from observation-based calendars such as Umm al-Qura. It is well
suited for deterministic formatting, tests and non-critical UI display.

## License

MIT — see [LICENSE](LICENSE).
