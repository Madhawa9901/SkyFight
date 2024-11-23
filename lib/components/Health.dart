import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:game/game.dart';

class HealthText extends TextComponent with HasGameRef<skyfight> {

  HealthText()
      :
        super(
        text: '10', // Initial text
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 48,
          ),
        ),
      );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2 - 400,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {

    final newText = gameRef.health.toString();
    if (text != newText) {
      text = newText;
    }
  }

}