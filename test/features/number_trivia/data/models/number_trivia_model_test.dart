import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_am_a_gamer/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be a subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from Json', () {
    test(' should return a valid model whdn JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
    test(
        ' should return a valid model when JSON number is regarded as a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });
  group('to Json', () {
    test('should return a JSON map containing the proper data', () {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
