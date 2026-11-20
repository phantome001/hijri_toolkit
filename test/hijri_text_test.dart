import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hijri_toolkit/hijri_toolkit.dart';

void main() {
  testWidgets('HijriText renders formatted Arabic date', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: HijriText(HijriDate(1445, 1, 1)),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.data, '٠١/٠١/١٤٤٥');
    expect(text.textDirection, TextDirection.rtl);
  });

  testWidgets('HijriText uses LTR for English locale', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: HijriText(
          const HijriDate(1445, 1, 1),
          formatter: const HijriFormatter(
            pattern: 'd MMMM yyyy',
            locale: HijriLocale.en,
            digits: HijriDigits.western,
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.data, '1 Muharram 1445');
    expect(text.textDirection, TextDirection.ltr);
  });

  testWidgets('HijriText respects an explicit textDirection', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: HijriText(
          HijriDate(1445, 1, 1),
          textDirection: TextDirection.ltr,
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.textDirection, TextDirection.ltr);
  });
}
