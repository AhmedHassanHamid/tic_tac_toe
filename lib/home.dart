import 'dart:math';

import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  String? _currentPlayer;
  String? _gameState;
  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _playMove(int row, int col) {
    setState(() {
      if (_currentPlayer == 'X') {
        widget._board[row][col] = 'X';
        _currentPlayer = 'O';
      } else {
        // Computer's turn
        // Generate a random move
        var emptyCells = _getEmptyCells();
        var randomCell = emptyCells[Random().nextInt(emptyCells.length)];
        widget._board[randomCell[0]][randomCell[1]] = 'O';
        _currentPlayer = 'X';
      }
    });
    _checkForWin();
  }
  List<List<int>> _getEmptyCells() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (widget._board[i][j] == '') {
          emptyCells.add([i, j]);
        }
      }
    }
    return emptyCells;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 390,
            decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
          ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () {
                    if (_gameState == 'ongoing') {
                      setState(() {
                        if (widget._board[row][col] == '') {
                          widget._board[row][col] = _currentPlayer!;
                          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
                          _checkForWin();
                          _playMove(row,col);
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    border: Border(
                      right: col < 2 ? BorderSide(width: 1, color: Colors.white) : BorderSide.none,
                      bottom: row < 2 ? BorderSide(width: 1, color: Colors.white) : BorderSide.none,
                    ),
                    color:  widget._board[row][col] == 'X' ? Colors.red :  widget._board[row][col] == 'O' ? Colors.blue : Colors.transparent,
                  ),
                    child: Center(
                      child: Text(
                        widget._board[row][col],
                        style: TextStyle(
                          fontSize: 72, color: Colors.white
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _gameState == 'ongoing'
              ? Container(
                  margin: EdgeInsets.all(16.0),
                  child: Text(
                    'Player $_currentPlayer\'s turn',
                    style: TextStyle(
                      fontSize: 24.0, color: Colors.white
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(16.0),
                  child: Text(
                    _gameState!,
                    style: TextStyle(
                      fontSize: 24.0,color: Colors.white
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _resetGame,
      ),
    );
  }

  _checkForWin() {
    // check rows
    for (int i = 0; i < 3; i++) {
      if (widget._board[i][0] == widget._board[i][1] &&
          widget._board[i][1] == widget._board[i][2] &&
          widget._board[i][0] != '') {
        setState(() {
          _gameState = 'Player ${widget._board[i][0]} wins!';
        });
        return;
      }
    }

    // check columns
    for (int i = 0; i < 3; i++) {
      if (widget._board[0][i] == widget._board[1][i] &&
          widget._board[1][i] == widget._board[2][i] &&
          widget._board[0][i] != '') {
        setState(() {
          _gameState = 'Player ${widget._board[0][i]} wins!';
        });
        return;
      }
    }

    // check diagonals
    if (widget._board[0][0] == widget._board[1][1] &&
        widget._board[1][1] == widget._board[2][2] &&
        widget._board[0][0] != '') {
      setState(() {
        _gameState = 'Player ${widget._board[0][0]} wins!';
      });
      return;
    }

    if (widget._board[0][2] == widget._board[1][1] &&
        widget._board[1][1] == widget._board[2][0] &&
        widget._board[0][2] != '') {
      setState(() {
        _gameState = 'Player ${widget._board[0][2]} wins!';
      });
      return;
    }

    // check for draw
    int emptySpaces = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (widget._board[i][j] == '') {
          emptySpaces++;
        }
      }
    }

    if (emptySpaces == 0) {
      setState(() {
        _gameState = 'It\'s a draw!';
      });
    }
  }

  _resetGame() {
    setState(() {
      widget._board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      _gameState = 'ongoing';
      _currentPlayer = 'X';
    });
  }
}
