import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/components/ground.dart';
import 'package:game/components/otherPlanes.dart';
import 'package:game/components/otherProjectiles.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

import 'myProjectiles.dart';

class MyPlane extends SpriteComponent with CollisionCallbacks,HasGameRef<skyfight>{
  MyPlane() : super(position: Vector2(planeStartX, planeStartY), size: Vector2(planeWidth, planeHeight));

  double velocity = 0;
  int collisionCount = 0;

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load('plane_2_blue.png');

    add(RectangleHitbox());
  }

  void fly(){
    velocity = trustStrength;
  }

  void fire() {
    // Spawn a projectile slightly in front of the plane
    final projectilePosition = Vector2(position.x + size.x, position.y + size.y / 2 - 5);
    final projectile = Projectile(projectilePosition, Vector2(20, 15), 300); // Adjust size and speed as needed
    parent?.add(projectile);
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;

    // Update position
    position.y += velocity * dt;

    // Prevent the plane from leaving the top of the screen
    if (position.y < 0) {
      position.y = 0;
      velocity = 0; // Reset velocity if it hits the top
    }

    // Prevent the plane from leaving the bottom of the screen
    if (position.y + size.y > gameRef.size.y) {
      position.y = gameRef.size.y - size.y; // Adjust position to stay within bounds
      velocity = 0; // Reset velocity if it hits the bottom
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if(other is Ground) {
      (parent as skyfight).gameOver();
    }
    if(other is OtherPlanes) {
      (parent as skyfight).gameOver();
    }
    if(other is OtherProjectile){
      collisionCount++;
      gameRef.decrementHealth();
      other.removeFromParent();
      if(collisionCount == 10) {
        (parent as skyfight).gameOver();
        collisionCount = 0;
      }
    }
  }

}