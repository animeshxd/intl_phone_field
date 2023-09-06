
import 'countries.dart';

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class PhoneNumber {

  final Country country;
  final String number;

  PhoneNumber({
    required this.country,
    required this.number,
  });

  factory PhoneNumber.fromCompleteNumber({required String completeNumber}) {
    var invalidPhoneNumber = PhoneNumber(
      country: const Country(
        name: '?',
        flag: '?',
        code: '?',
        dialCode: '?',
        nameTranslations: {},
        minLength: 0,
        maxLength: 0,
      ),
      number: "",
    );
    if (completeNumber == "") {
      return invalidPhoneNumber;
    }

    try {
      Country country = getCountry(completeNumber);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber.substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber.substring(country.dialCode.length + country.regionCode.length);
      }
      return PhoneNumber(country: country, number: number);
    } on InvalidCharactersException {
      rethrow;
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      return invalidPhoneNumber;
    }
  }

  bool isValidNumber() {
    Country country = getCountry(completeNumber);
    if (number.length < country.minLength || number.isEmpty) {
      throw NumberTooShortException();
    }

    if (number.length > country.maxLength) {
      throw NumberTooLongException();
    }
    return true;
  }

  String get completeNumber {
    return countryCode + number;
  }

  String get countryCode => "+${country.dialCode}${country.regionCode}";

  static Country getCountry(String phoneNumber) {
    if (phoneNumber == "") {
      throw NumberTooShortException();
    }

    final validPhoneNumber = RegExp(r'^[+0-9]*[0-9]*$');

    if (!validPhoneNumber.hasMatch(phoneNumber)) {
      throw InvalidCharactersException();
    }

    if (phoneNumber.startsWith('+')) {
      return countries
          .firstWhere((country) => phoneNumber.substring(1).startsWith(country.dialCode + country.regionCode));
    }
    return countries.firstWhere((country) => phoneNumber.startsWith(country.dialCode + country.regionCode));
  }

  @override
  String toString() => 'PhoneNumber(countryISOCode: ${country.code}, countryCode: $countryCode, number: $number)';
}
