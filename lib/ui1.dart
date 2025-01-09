import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marioo/barriers.dart';

class Uii1 extends StatefulWidget {
  const Uii1({super.key});

  @override
  State<Uii1> createState() => _Uii1State();
}

class _Uii1State extends State<Uii1> {
  static double birdyaxis = 0;
  double time = 0;
  double height = 0;
  double initialheight = birdyaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  bool gameOver = false;
  int score = 0; // Current score
  int bestScore = 0; // Best score

  void jump() {
    setState(() {
      time = 0;
      initialheight = birdyaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    gameOver = false;
    score = 1; // Reset current score at the start of the game

    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdyaxis = initialheight - height;

        // Move barriers and update score
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++; // Increment score when the first barrier passes
        } else {
          barrierXone -= 0.05;
        }

        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++; // Increment score when the second barrier passes
        } else {
          barrierXtwo -= 0.05;
        }

        // Check for collision or game over conditions
        if (checkCollision() || birdyaxis > 1 || birdyaxis < -1) {
          timer.cancel();
          gameHasStarted = false;
          gameOver = true;
          if (score > bestScore) {
            bestScore = score; // Update best score if current score is higher
          }
          showGameOverDialog();
        }
      });
    });
  }

  bool checkCollision() {
    double birdHeight = 70; // Height of the bird
    double barrierHeightTop = 200; // Height of top barrier
    double barrierHeightBottom = 250; // Height of bottom barrier

    bool collisionWithBarrierOne =
        barrierXone > -0.5 && barrierXone < 0.5 && (birdyaxis < -1 + (barrierHeightTop / 500) || birdyaxis > 1 - (barrierHeightBottom / 500));
    bool collisionWithBarrierTwo =
        barrierXtwo > -0.5 && barrierXtwo < 0.5 && (birdyaxis < -1 + (barrierHeightTop / 500) || birdyaxis > 1 - (barrierHeightBottom / 500));

    return collisionWithBarrierOne || collisionWithBarrierTwo;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your score: $score\nBest score: $bestScore\nWould you like to restart the game?"),
          actions: [
            TextButton(
              onPressed: () {
                resetGame(); // Reset game state when "Cancel" is pressed
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      birdyaxis = 0;
      time = 0;
      height = 0;
      initialheight = birdyaxis;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      gameHasStarted = false;
      gameOver = false;
      score = 0; // Reset current score when restarting
    });
    // Optionally start the game again if needed
    // startGame(); // Uncomment if you want to start automatically
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else if (gameOver) {
          // No action needed here as the dialog is handled
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdyaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://i0.wp.com/blog.threadless.com/blog/wp-content/uploads/2016/02/flappybird.png?resize=312%2C271&ssl=1",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameHasStarted
                        ? Text("")
                        : Text(
                      "T A P TO  P L A Y",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: barrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: barrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: barrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: barrier(
                      size: 250.0,
                    ),
                  ),
                  if (gameOver) ...[
                    Center(
                      child: Text(
                        "GAME OVER",
                        style: TextStyle(fontSize: 40, color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "$score", // Display the dynamic current score
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "$bestScore", // Display the best score
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
