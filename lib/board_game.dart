import 'dart:math';

import 'package:flutter/cupertino.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({Key? key}) : super(key: key);

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame>
    with SingleTickerProviderStateMixin {
  List<int> snakePosition = [];
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);

  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  void startGame() {
    snakePosition = [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
