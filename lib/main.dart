import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/aboutScreen.dart';
import 'package:game/screens/highScoreScreen.dart';
import 'package:game/screens/startMenu.dart';
import 'game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start with the StartMenu
      routes: {
        '/': (context) => const StartMenu(), // Display the StartMenu first
        '/game': (context) => GameWidget(game: skyfight()), // Adjust based on your Flame integration
        '/high-scores': (context) => const HighScoresScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skyfight game = skyfight(); // Instantiate the game

    return Scaffold(
      body: Stack(
        children: [
          // The game widget
          GameWidget(game: game),

          // Detect taps for game actions
          GestureDetector(
            onTap: () {
              game.plane.fire(); // Trigger the fire method of the plane
              game.plane.fly();
            },
          ),

          // Add a back button to return to StartMenu
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Return to StartMenu
              },
            ),
          ),
        ],
      ),
    );
  }
}
