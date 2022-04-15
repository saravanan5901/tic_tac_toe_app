import 'package:flutter/material.dart';
import 'package:tic_tac_toe_package/widgets/utils.dart';
import 'package:tic_tac_toe_package/ai/utils.dart';
import 'package:tic_tac_toe_package/ai/ai.dart';

class SinglePlayer extends StatefulWidget {
  const SinglePlayer({Key? key}) : super(key: key);

  @override
  SinglePlayerState createState() => SinglePlayerState();
}

class SinglePlayerState extends State<SinglePlayer> {
  late List<int> board;
  late int _currentPlayer;
  late GamePresenter _presenter;
  static const countMatrix = 3;
  static const double size = 92;
  static const none = '';
  static const X = 'X';
  static const O = 'O';
  int oScore = 0;
  int xScore = 0;

  String lastMove = none;
  late List<List<String>> matrix;

  @override
  void initState() {
    super.initState();
    setEmptyFields();
    reinitialize();
  }

  void reinitialize() {
    _currentPlayer = Ai.human;
    // generate the initial board
    board = List.generate(9, (idx) => 0);
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => none),
      ));

  Color getFieldColor(String value) {
    switch (value) {
      case O:
        return Colors.blue;
      case X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  SinglePlayerState() {
    _presenter = GamePresenter(_movePlayed, _onGameEnd);
  }

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.human) {
        // switch to AI player
        _currentPlayer = Ai.ai;
        _presenter.onHumanPlayed(board, matrix);
      } else {
        _currentPlayer = Ai.human;
      }
    });
  }

  String? getSymbolForIdx(int idx) {
    return Ai.symbols[board[idx]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.withAlpha(225),
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.red,
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Player X (YOU)',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      xScore.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.blue,
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Player O (AI)',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(
                      oScore.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => clearScoreBoard(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text(
                    "Clear Score Board",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(int x) {
    final values = matrix[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(size, size),
          primary: color,
        ),
        child: Text(value, style: const TextStyle(fontSize: 32)),
        onPressed: () => selectField(value, x, y),
      ),
    );
  }

  void selectField(String value, int x, int y) {
    int idx = 3 * x + y;
    if (value == none) {
      const newValue = X;

      setState(() {
        board[idx] = _currentPlayer;
        lastMove = newValue;
        matrix[x][y] = newValue;
        if (_currentPlayer == Ai.human) {
          // switch to AI player
          _currentPlayer = Ai.ai;
          _presenter.onHumanPlayed(board, matrix);
        } else {
          _currentPlayer = Ai.human;
        }
      });
    }
  }

  void clearScoreBoard() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: const Text(
          'Restart the Game ',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Clearing the scoreboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Restart'),
            onPressed: () {
              oScore = 0;
              xScore = 0;
              reinitialize();
              setEmptyFields();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _onGameEnd(int winner) {
    String title;
    String content;
    MaterialColor winnerColor;
    switch (winner) {
      case Ai.human: // will never happen :)
        title = "Congratulations!";
        content = "You beat an AI!";
        winnerColor = Colors.red;
        xScore++;
        break;
      case Ai.ai:
        title = "Player O (AI) won";
        content = "Player X (YOU) lose";
        winnerColor = Colors.blue;
        oScore++;
        break;
      default:
        title = "Draw";
        content = "No winners here";
        winnerColor = Colors.green;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: winnerColor,
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    setState(() {
                      setEmptyFields();
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("play again"))
            ],
          );
        });
  }
}

class GamePresenter {
  void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) showGameEnd;

  late Ai _aiPlayer;

  GamePresenter(this.showMoveOnUi, this.showGameEnd) {
    _aiPlayer = Ai();
  }

  void onHumanPlayed(List<int> board, List<List<String>> matrix) async {
    int evaluation = AIUtils.evaluateBoard(board);
    if (evaluation != Ai.noWinnersYet) {
      onGameEnd(evaluation);
      return;
    }

    int aiMove = await Future(() => _aiPlayer.play(board, Ai.ai));

    board[aiMove] = Ai.ai;
    matrix[aiMove ~/ 3][aiMove % 3] = 'O';

    evaluation = AIUtils.evaluateBoard(board);
    if (evaluation != Ai.noWinnersYet) {
      onGameEnd(evaluation);
    } else {
      showMoveOnUi(aiMove);
    }
  }

  void onGameEnd(int winner) {
    if (winner == Ai.ai) {}
    showGameEnd(winner);
  }
}
