import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/utils/numerals.dart';

void main() {
  test('apply converts from any digit system to the target', () {
    expect(Numerals.western.apply('١٢:٣٠ ۴۵'), '12:30 45');
    expect(Numerals.arabicIndic.apply('Page 42'), 'Page ٤٢');
    expect(Numerals.persian.apply('٢٥٥'), '۲۵۵');
  });

  test('automatic choice follows region, then language', () {
    Numerals auto(String lang, String? country) => Numerals.resolve(
      NumeralStyle.auto,
      languageCode: lang,
      countryCode: country,
    );
    expect(auto('ar', 'MA'), Numerals.western);
    expect(auto('ar', 'DZ'), Numerals.western);
    expect(auto('ar', 'EG'), Numerals.arabicIndic);
    expect(auto('ar', 'SA'), Numerals.arabicIndic);
    expect(auto('ar', null), Numerals.western);
    expect(auto('ur', 'PK'), Numerals.persian);
    expect(auto('fr', 'FR'), Numerals.western);
  });

  test('the percent sign and decimal point follow the digits', () {
    expect(Numerals.arabicIndic.apply('12% read'), '١٢٪ read');
    expect(
      Numerals.arabicIndic.apply('93.7° from north.'),
      '٩٣٫٧° from north.',
    );
    expect(Numerals.persian.apply('5%'), '۵٪');
    expect(Numerals.western.apply('٩٣٫٧ ٪'), '93.7 %');
    // Bengali date formatting writes its own digits; they follow the setting.
    expect(Numerals.western.apply('৫:০৯'), '5:09');
    // A full stop that ends a sentence is not a decimal point.
    expect(Numerals.arabicIndic.apply('Page 4. Next'), 'Page ٤. Next');
  });

  test('an explicit choice wins over the region', () {
    expect(
      Numerals.resolve(
        NumeralStyle.arabicIndic,
        languageCode: 'ar',
        countryCode: 'MA',
      ),
      Numerals.arabicIndic,
    );
  });
}
