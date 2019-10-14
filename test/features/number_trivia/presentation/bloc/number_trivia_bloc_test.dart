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
      test(
          'should call the InputConverter validate and convert the string to an unsigned integer',
          () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      });
    });
  });
}
