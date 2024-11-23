import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final skyfight game = skyfight(); // Instantiate the game

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // The game widget
          GameWidget(game: game),

          GestureDetector(
            onTap: () {
              game.plane.fire(); // Trigger the fire method of the plane
              game.plane.fly();
            },
          ),
        ],
      ),
    );
  }
}
