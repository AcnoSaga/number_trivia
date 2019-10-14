import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_am_a_gamer/core/util/input_converter.dart';

void main() {
  InputConverter inputConvertor;
  setUp(() {
    inputConvertor = InputConverter();
  });
  group('stringToUnsignedInt', () {
    test(
        'shouldreturn an integer when the string represents an unsigned integer',
        () {
      final str = '123';
      final result = inputConvertor.stringToUnsignedInteger(str);
      expect(result, equals(Right(123)));
    });
    test('should return a Failure when the string is not an integer', () {
      final str = 'abc';
      final result = inputConvertor.stringToUnsignedInteger(str);
      expect(result, equals(Left(InvalidInputFailure())));
    });
    test('should return a Failure when the string is a negative integer', () {
      final str = '-123';
      final result = inputConvertor.stringToUnsignedInteger(str);
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
