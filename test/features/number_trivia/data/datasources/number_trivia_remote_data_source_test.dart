import 'dart:convert';

import 'package:i_am_a_gamer/core/error/exceptions.dart';
import 'package:i_am_a_gamer/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:i_am_a_gamer/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  void setUpMockClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 400));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      setUpMockClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });
    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other error codes',
        () {
      setUpMockClientFailure404();
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      setUpMockClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });
    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other error codes',
        () {
      setUpMockClientFailure404();
      final call = dataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
