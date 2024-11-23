import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:game/game.dart';

class ScoreText extends TextComponent with HasGameRef<skyfight> {
  ScoreText(): super(
      text: '0',
      textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 48,
          )
      ),
  );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if(text != newText) {
      text = newText;
    }
  }

}