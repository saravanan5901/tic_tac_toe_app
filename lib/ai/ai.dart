import 'package:tic_tac_toe_package/ai/utils.dart';

class Ai {
  static const int human = 1;
  static const int ai = -1;
  static const int noWinnersYet = 0;
  static const int draw = 2;

  static const int emptySpace = 0;
  static const symbols = {emptySpace: "", human: "X", ai: "O"};

  static const int winScore = 100;
  static const int drawScore = 0;
  static const int loseScore = -100;

  static const winConditionList = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  int play(List<int> board, int currentPlayer) {
    return _getBestMove(board, currentPlayer).move;
  }

  int _getBestScore(List<int> board, int currentPlayer) {
    int evaluation = AIUtils.evaluateBoard(board);

    if (evaluation == currentPlayer) return winScore;

    if (evaluation == draw) return drawScore;

    if (evaluation == AIUtils.flipPlayer(currentPlayer)) {
      return loseScore;
    }

    return _getBestMove(board, currentPlayer).score;
  }

  Move _getBestMove(List<int> board, int currentPlayer) {
    List<int> newBoard;
    Move bestMove = Move(score: -10000, move: -1);

    for (int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!AIUtils.isMoveLegal(board, currentMove)) continue;

      newBoard = List.from(board);

      newBoard[currentMove] = currentPlayer;

      int nextScore =
          -_getBestScore(newBoard, AIUtils.flipPlayer(currentPlayer));

      if (nextScore > bestMove.score) {
        bestMove.score = nextScore;
        bestMove.move = currentMove;
      }
    }

    return bestMove;
  }
}

class Move {
  int score;
  int move;

  Move({required this.score, required this.move});
}
