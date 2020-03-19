import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
import 'bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (value) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: value));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (value) => Loaded(trivia: value),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
        break;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
        break;
      default:
        return 'Unexpected Error';
    }
  }
}
