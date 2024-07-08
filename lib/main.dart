import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Map<String, int> _userScores = {};

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String key = '$email:$password';

      int score = _userScores[key] ?? 0;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicTacToeScreen(
            email: email,
            password: password,
            score: score,
            onScoreUpdated: (newScore) {
              setState(() {
                _userScores[key] = newScore;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  final String email;
  final String password;
  final int score;
  final Function(int) onScoreUpdated;

  TicTacToeScreen({
    required this.email,
    required this.password,
    required this.score,
    required this.onScoreUpdated,
  });

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  String _currentPlayer = 'X';
  late int _score;

  @override
  void initState() {
    super.initState();
    _score = widget.score;
  }

  void _resetBoard() {
    setState(() {
      _board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', '']
      ];
      _currentPlayer = 'X';
    });
  }

  void _updateScore() {
    setState(() {
      _score++;
    });
    widget.onScoreUpdated(_score);
  }

  void _handleTap(int row, int col) {
    if (_board[row][col] == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWin(_currentPlayer)) {
          _updateScore();
          _showWinDialog(_currentPlayer);
        } else if (_isBoardFull()) {
          _showDrawDialog();
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWin(String player) {
    // Check rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == player &&
          _board[i][1] == player &&
          _board[i][2] == player) {
        return true;
      }
      if (_board[0][i] == player &&
          _board[1][i] == player &&
          _board[2][i] == player) {
        return true;
      }
    }
    if (_board[0][0] == player &&
        _board[1][1] == player &&
        _board[2][2] == player) {
      return true;
    }
    if (_board[0][2] == player &&
        _board[1][1] == player &&
        _board[2][0] == player) {
      return true;
    }
    return false;
  }

  bool _isBoardFull() {
    for (var row in _board) {
      for (var cell in row) {
        if (cell == '') {
          return false;
        }
      }
    }
    return true;
  }

  void _showWinDialog(String player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Player $player Wins!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('It\'s a Draw!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text('Score: $_score'),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _board
            .asMap()
            .entries
            .map((entry) => _buildRow(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  Widget _buildRow(int rowIndex, List<String> row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row
          .asMap()
          .entries
          .map((entry) => _buildCell(rowIndex, entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildCell(int row, int col, String value) {
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(4.0),
        color: Colors.blue[100],
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
