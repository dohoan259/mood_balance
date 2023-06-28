import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const size = Size(512, 512);
final rd = Random();
const gridSize = 32.0;
const tile = Offset(32, 32);
const loop = Duration(milliseconds: 300);

enum Direction { top, left, bottom, right }

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      );
}

class MainScreen extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  final game = Game();

  MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _onKey,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('KEYS : ⬅ ➡ to turn, SPACE to Pause'),
              AnimatedBuilder(
                animation: game,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Card(
                        child:
                            CustomPaint(size: size, painter: GamePainter(game)),
                      ),
                      if (!game.isRunning)
                        Positioned.fill(
                          child: InkWell(
                            onTap: game.run,
                            child: Container(
                              color: Colors.yellow,
                              child:
                                  const Center(child: Text('Click to start')),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onKey(RawKeyEvent value) {
    if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      game.rotate(Direction.right);
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      game.rotate(Direction.left);
    } else if (value.isKeyPressed(LogicalKeyboardKey.space)) {
      game.togglePause();
    }
  }
}

final snakeFill = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.fill;

final appleFill = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.fill;

class GamePainter extends CustomPainter {
  final Game game;

  GamePainter(this.game);

  @override
  void paint(Canvas canvas, Size size) {
    final snake = game.snake;

    canvas.drawCircle(game.target + tile / 2, 16, appleFill);

    canvas.drawRect(
      Rect.fromPoints(snake.position, snake.position + tile),
      snakeFill,
    );
    for (final part in game.snake.tail) {
      canvas.drawRect(Rect.fromPoints(part, part + tile), snakeFill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Game extends ChangeNotifier {
  bool paused = false;

  final Snake snake;

  late Offset target;

  Timer? timer;

  Game() : snake = Snake() {
    init();
  }

  bool get isRunning => timer != null;

  void init() {
    snake.init();
    newApple();
  }

  run() {
    timer = Timer.periodic(loop, (timer) {
      if (!paused) update();
    });
  }

  void rotate(Direction dir) {
    switch (dir) {
      case Direction.left:
        switch (snake.direction) {
          case Direction.top:
            snake.move(Direction.left);
            break;
          case Direction.left:
            snake.move(Direction.bottom);
            break;
          case Direction.bottom:
            snake.move(Direction.right);
            break;
          case Direction.right:
            snake.move(Direction.top);
            break;
        }
        break;
      case Direction.right:
      default:
        switch (snake.direction) {
          case Direction.top:
            snake.move(Direction.right);
            break;
          case Direction.left:
            snake.move(Direction.top);
            break;
          case Direction.bottom:
            snake.move(Direction.left);
            break;
          case Direction.right:
            snake.move(Direction.bottom);
            break;
        }
        break;
    }
  }

  void update() {
    snake.update(target);

    if (target == snake.position) {
      newApple();
    }
    notifyListeners();
    if (snake.out) clear();
    if (snake.overlap) clear();
  }

  void newApple() {
    target = Offset(
      (rd.nextInt(size.width ~/ gridSize) * tile.dx).floorToDouble(),
      (rd.nextInt(size.height ~/ gridSize) * tile.dy).floorToDouble(),
    );
  }

  void clear() {
    snake.clear();
    timer?.cancel();

    init();
    run();
  }

  void togglePause() => paused = !paused;
}

class Snake {
  Direction direction = Direction.right;

  Offset position = tile * 2;

  List<Offset> tail = [];

  bool get out => !size.contains(position);

  bool get overlap => [position, ...tail].length != {position, ...tail}.length;

  void init() {
    direction = Direction.right;
    position = tile * 2;
  }

  void move(Direction dir) => direction = dir;

  void update(Offset apple) {
    final previousPosition = position;

    switch (direction) {
      case Direction.top:
        position += const Offset(0, -gridSize);
        break;
      case Direction.left:
        position += const Offset(-gridSize, 0);
        break;
      case Direction.bottom:
        position += const Offset(0, gridSize);
        break;
      case Direction.right:
        position += const Offset(gridSize, 0);
        break;
    }

    final grow = position == apple;
    if (tail.isNotEmpty) {
      tail = [previousPosition, ...tail, if (grow) tail.last]..removeLast();
    } else if (grow) {
      tail = [previousPosition];
    }
  }

  void clear() => tail.clear();
}
