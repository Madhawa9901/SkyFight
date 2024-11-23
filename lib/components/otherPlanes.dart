import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

import 'otherProjectiles.dart';

class OtherPlanes extends SpriteComponent with CollisionCallbacks, HasGameRef<skyfight> {
  double fireCooldown = 1.5;
  double fireTimer = 0;

  OtherPlanes(Vector2 position, Vector2 size)
    : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load('plane_2_red_flipped.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundScrollSpeed * dt;

    if(position.x + size.x <= 0) {
      removeFromParent();
    }

    fireTimer += dt;
    if(fireTimer >= fireCooldown && isAlligned()) {
      fireProjectile();
      fireTimer = 0;
    }
  }

  bool isAlligned(){
    final playerPlane = gameRef.plane;
    return (position.y - playerPlane.position.y).abs() < size.y;
  }

  void fireProjectile() {
    final projectile = OtherProjectile(
      position: position.clone(),
      size: Vector2(15, 10),
      speed: 300,
      direction: Vector2(-1, 0),
    );
    gameRef.add(projectile);
  }

}