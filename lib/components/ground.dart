import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

class Ground extends SpriteComponent with HasGameRef<skyfight>, CollisionCallbacks{
  Ground() : super();

  @override
  Future<FutureOr<void>> onLoad() async {
    size = Vector2(4*gameRef.size.x, gameRef.size.y);
    position = Vector2(0, gameRef.size.y - mount1Height);

    sprite = await Sprite.load('Ground.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundScrollSpeed * dt;

    if(position.x + size.x/3 <= 0) {
      position.x = 0;
    }

  }
}