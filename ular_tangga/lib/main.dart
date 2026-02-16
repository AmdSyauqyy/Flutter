import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(UlarTanggaApp());

class UlarTanggaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Comic Sans MS'),
      home: GameBoard(),
    );
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int playerPosition = 1;
  int diceValue = 1;
  bool isMoving = false;

  final Map<int, int> snakes = {17: 4, 34: 12, 48: 25};

  final Map<int, int> ladders = {3: 15, 8: 30, 20: 42};

  void rollDice() async {
    if (isMoving) return;

    setState(() {
      isMoving = true;
      diceValue = Random().nextInt(6) + 1;
    });

    for (int i = 0; i < diceValue; i++) {
      if (playerPosition < 50) {
        await Future.delayed(Duration(milliseconds: 300));
        setState(() {
          playerPosition++;
        });
      }
    }

    if (ladders.containsKey(playerPosition)) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        playerPosition = ladders[playerPosition]!;
      });
      _showMessage("Curang naik tangga");
    } else if (snakes.containsKey(playerPosition)) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        playerPosition = snakes[playerPosition]!;
      });
      _showMessage("Awkawok kena gigit uler");
    }

    if (playerPosition >= 50) {
      _showWinDialog();
    }

    setState(() => isMoving = false);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 1)),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Loh menang"),
        content: Text("Hoki doang bisa sampe puncak"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => playerPosition = 1);
              Navigator.pop(context);
            },
            child: Text("Main Lagi"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4E0),
      appBar: AppBar(
        title: Text("Vrissya & Tangga"),
        backgroundColor: const Color.fromARGB(255, 255, 152, 0),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                reverse: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: 50,
                itemBuilder: (context, index) {
                  int row = index ~/ 10;
                  int cellNumber;

                  if (row % 2 == 0) {
                    cellNumber = index + 1;
                  } else {
                    cellNumber = (row + 1) * 10 - (index % 10);
                  }

                  bool isPlayerHere = playerPosition == cellNumber;

                  return Container(
                    decoration: BoxDecoration(
                      color: cellNumber % 2 == 0
                          ? Colors.white
                          : Color(0xFFFFE5D9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      boxShadow: [
                        if (isPlayerHere)
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "$cellNumber",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        if (ladders.containsKey(cellNumber))
                          Text("🪜", style: TextStyle(fontSize: 20)),
                        if (snakes.containsKey(cellNumber))
                          Text("🐍", style: TextStyle(fontSize: 20)),
                        if (isPlayerHere)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: ClipOval(
                              child: Image.asset(
                                'IMG-20260211-WA0038.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Dadu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "$diceValue",
                style: TextStyle(fontSize: 40, color: Colors.orange),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isMoving ? null : rollDice,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "KOCOK DADU",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
