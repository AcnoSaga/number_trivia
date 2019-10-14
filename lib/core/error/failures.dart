import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
