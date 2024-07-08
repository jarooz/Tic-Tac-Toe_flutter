# Tic-Tac-Toe Flutter App

This is a simple Flutter application demonstrating a login screen and a Tic-Tac-Toe game. The application allows users to log in with an email and password, play a game of Tic-Tac-Toe, and keeps track of scores associated with each email and password combination.


## Screenshots

**Login Screen**

![Login Screen](/screenshots/Login%20Screen.png)

**Logged in with Email**

![Logged in with Email](/screenshots/Logged%20in%20with%20Email.png)

**Tic-Tac-Toe Game**

![Tic-Tac-Toe Game](/screenshots/Tic-Tac-Toe%20Game.png)

**Player Wins**

![Player Wins](/screenshots/Player%20Wins.png)

## How to Run
**Prerequisites**
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- VSCode: [Install VSCode](https://code.visualstudio.com/)
- Dart and Flutter extensions for VSCode

**Steps to Run**

1. **Clone the Repository**
    ```
    git clone https://github.com/yourusername/tic-tac-toe-flutter.git
    cd tic-tac-toe-flutter
    ```
2. **Open the Project in VSCode**
    ```
    code .
    ```
3. **Run the App**

    Connect your device or start an emulator and run the app:
    ```
    flutter run
    ```
    Alternatively, press F5 in VSCode to start debugging.

## Code Explanation

**main.dart**

```
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
```
- MyApp Class: The root of the application, setting up the MaterialApp and initial screen.

**Login Screen**
```
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
      appBar: AppBar(title: Text('Login')),
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
```