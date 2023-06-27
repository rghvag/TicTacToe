import 'package:flutter/material.dart';
// import 'dart:js' show context;

class homePage extends StatefulWidget {
  homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  static const String Player_x = "X";
  static const String Player_y = "O";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = Player_x;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _headerText(),
          _gameContainer(),
          _restartbutton(),
        ],
      )),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentPlayer turn",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        if (gameEnd || occupied[index].isNotEmpty)
          // return if game already ended or box already clicked
          return;

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkforWinner();
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == Player_x
                ? Colors.blue
                : Colors.orange,
        child: Center(
            child: Text(
          occupied[index],
          style: TextStyle(
            fontSize: 50,
          ),
        )),
      ),
    );
  }

  _restartbutton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: Text("Restart Game"));
  }

  changeTurn() {
    if (currentPlayer == Player_x) {
      currentPlayer = Player_y;
    } else {
      currentPlayer = Player_x;
    }
  }

  checkforWinner() {
    //defiining wining ppostions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition2 == playerPosition0) {
          showGameOverMessage("Player $playerPosition0 won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over \n $message",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
