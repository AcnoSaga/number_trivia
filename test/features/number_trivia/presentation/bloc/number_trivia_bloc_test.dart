import 'package:i_am_a_gamer/core/error/failures.dart';
import 'package:i_am_a_gamer/core/usecases/usecase.dart';
import 'package:i_am_a_gamer/core/util/input_converter.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:i_am_a_gamer/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
      random: mockGetRandomNumberTrivia,
    );
    test('initialState should be empty', () {
      expect(bloc.initialState, Empty());
    });

    group('GetTriviaForConcreteNumber', () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTrivia = NumberTrivia(number: 1, text: 'Test trivia');

      void setUpMockInputConverterSucccess() =>
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));

      test(
          'should call the InputConverter to validate and convert the string to an unsigned integer',
          () async {
        setUpMockInputConverterSucccess();
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      });
      test('should emit [Error] when the input is invalid', () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
      test('should get data from the concrete use case', () async {
        setUpMockInputConverterSucccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      });
      test('should [Loading, Loaded] when data is gotten successfully', () {
        setUpMockInputConverterSucccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
      test(
          'should [Loading, Error] with a proper message for the error when getting data fails',
          () {
        setUpMockInputConverterSucccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
      test('should [Loading, Error] when getting data fails', () {
        setUpMockInputConverterSucccess();

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
    });

    group('GetTriviaForRandomNumber', () {
      final tNumberTrivia = NumberTrivia(number: 1, text: 'Test trivia');

      test('should get data from the random use case', () async {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        verify(mockGetRandomNumberTrivia(NoParams()));
      });
      test('should [Loading, Loaded] when data is gotten successfully', () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });
      test(
          'should [Loading, Error] with a proper message for the Error when getting data fails',
          () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });
      test('should [Loading, Error] when getting data fails', () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expect(bloc.state, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });
    });
  });
  bloc.close();
}
