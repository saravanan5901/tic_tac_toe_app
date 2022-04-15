import 'package:flutter/material.dart';
import 'package:tic_tac_toe_package/widgets/utils.dart';

class TwoPlayer extends StatefulWidget {
  const TwoPlayer({Key? key}) : super(key: key);

  @override
  TwoPlayerState createState() => TwoPlayerState();
}

class TwoPlayerState extends State<TwoPlayer> {
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
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => none),
      ));

  Color getBackgroundColor() {
    final thisMove = lastMove == X ? O : X;

    return getFieldColor(thisMove).withAlpha(225);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
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
                        'Player X',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        xScore.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
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
                      const Text('Player O',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                        oScore.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
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
            )
          ],
        ),
      );

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
    if (value == none) {
      final newValue = lastMove == X ? O : X;

      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Undecided Game');
      }
    }
  }

  bool isEnd() =>
      matrix.every((values) => values.every((value) => value != none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    const n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
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
              setEmptyFields();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showEndDialog(String title) {
    MaterialColor winnerColor;
    if (title == 'Player O Won') {
      winnerColor = Colors.blue;
      oScore++;
    } else if (title == 'Player X Won') {
      winnerColor = Colors.red;
      xScore++;
    } else {
      winnerColor = Colors.green;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: winnerColor,
        content: Text(title, style: const TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: const Text('play again'),
            onPressed: () {
              setEmptyFields();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
