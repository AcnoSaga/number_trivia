import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  get props => [text, number];

  NumberTrivia({
    @required this.text,
    @required this.number,
  });
}
