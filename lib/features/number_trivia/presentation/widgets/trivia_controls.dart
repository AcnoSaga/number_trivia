import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_am_a_gamer/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:i_am_a_gamer/features/number_trivia/presentation/bloc/number_trivia_event.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onSubmitted: (_) {
            dispatchConcrete();
          },
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputString = value;
          },
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                color: Colors.white54,
                onPressed: dispatchRandom,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
