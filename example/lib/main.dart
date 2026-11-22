// Flutter 3.47 moved Material widgets to package:material_ui. This example
// also runs on older SDKs, where this is still the only import available.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:hijri_toolkit/hijri_toolkit.dart';

/// Shows the same Hijri day formatted in Arabic and English.
void main() => runApp(const HijriExampleApp());

/// Root widget of the example.
class HijriExampleApp extends StatelessWidget {
  /// Creates the example app.
  const HijriExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const date = HijriDate(1445, 1, 1);
    return MaterialApp(
      title: 'hijri_toolkit example',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('hijri_toolkit')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                HijriText(
                  date,
                  formatter: HijriFormatter(
                    pattern: 'EEEE، d MMMM yyyy',
                    locale: HijriLocale.ar,
                    digits: HijriDigits.arabic,
                  ),
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 16),
                HijriText(
                  date,
                  formatter: HijriFormatter(
                    pattern: 'EEEE, d MMMM yyyy',
                    locale: HijriLocale.en,
                    digits: HijriDigits.western,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text('Gregorian: 2023-07-18'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
