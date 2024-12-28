import 'dart:async';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game/components/Health.dart';
import 'package:game/components/background.dart';
import 'package:game/components/ground.dart';
import 'package:game/components/myProjectiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/components/otherProjectiles.dart';
import 'package:game/components/plane.dart';
import 'package:flame/game.dart';
import 'package:game/components/planeManager.dart';
import 'package:game/components/score.dart';
import 'package:game/constant.dart';

class skyfight extends FlameGame with TapDetector, HasCollisionDetection {
  late MyPlane plane;
  late Background background;
  late Ground ground;
  late PlaneManager planeManager;
  late ScoreText scoreText;
  late HealthText healthText;

  int score = 0;
  int health = 10;
  bool isGameOver = false;

  @override
  FutureOr<void> onLoad() {
    background = Background(size);
    add(background);

    plane = MyPlane();
    add(plane);

    ground = Ground();
    add(ground);

    planeManager = PlaneManager();
    add(planeManager);

    scoreText = ScoreText();
    add(scoreText);

    healthText = HealthText();
    add(healthText);
  }

  @override
  void onTap() {
    plane.fly();
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    plane.fire();
  }

  void incrementScore() {
    score += 1;
  }

  void decrementHealth() {
    health -= 1;
    if (health <= 0) {
      gameOver();
    }
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();

    final TextEditingController nameController = TextEditingController();

    if (buildContext != null) {
      showDialog(
        barrierDismissible: false,
        context: buildContext!,
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your name to save your score:'),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Your Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await uploadScore(name, score);
                }
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Main Menu'),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await uploadScore(name, score);
                  print(score);
                  Navigator.pushNamed(context, '/game');
                }
                Navigator.pop(context);
                Navigator.pushNamed(context, '/game');
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    plane.position = Vector2(planeStartX, planeStartY);
    plane.velocity = 0;
    isGameOver = false;
    score = 0;
    health = 10;
    children
        .whereType<PlaneManager>()
        .toList()
        .forEach((otherPlane) => otherPlane.removeFromParent());
    children
        .whereType<OtherProjectile>()
        .toList()
        .forEach((otherprojectiles) => otherprojectiles.removeFromParent());
    children
        .whereType<Projectile>()
        .toList()
        .forEach((projectiles) => projectiles.removeFromParent());
    resumeEngine();
  }
}

Future<void> uploadScore(String name, int currentScore) async {
  try {
    // Reference to the Firestore collection
    final CollectionReference scoresCollection =
    FirebaseFirestore.instance.collection('scores');

    // Query Firestore to check if the name exists
    final QuerySnapshot querySnapshot = await scoresCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the name exists, check the existing score
      final DocumentReference existingDoc = querySnapshot.docs.first.reference;
      final Map<String, dynamic> existingData =
      querySnapshot.docs.first.data() as Map<String, dynamic>;

      final int firebaseScore = existingData['score'] ?? 0;

      if (currentScore > firebaseScore) {
        // Update Firestore if the current score is higher
        await existingDoc.update({
          'score': currentScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Score updated successfully!');
      } else {
        print('Current score is not higher than the stored score.');
      }
    } else {
      // If the name does not exist, add a new document
      await scoresCollection.add({
        'name': name,
        'score': currentScore,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Score added successfully!');
    }
  } catch (e) {
    print('Failed to upload score: $e');
  }
}
