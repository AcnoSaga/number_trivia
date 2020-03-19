import 'package:flutter/material.dart';
import 'package:i_am_a_gamer/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({
    Key key,
    this.numberTrivia,
  }) : super(key: key);

  final NumberTrivia numberTrivia;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            numberTrivia.number.toString(),
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(
                  numberTrivia.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
