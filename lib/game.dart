import 'dart:async';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game/components/Health.dart';
import 'package:game/components/background.dart';
import 'package:game/components/ground.dart';
import 'package:game/components/myProjectiles.dart';
import 'package:game/components/otherPlanes.dart';
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

    if (buildContext != null) {
      showDialog(
        context: buildContext!,
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
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
