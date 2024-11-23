import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

import 'otherPlanes.dart';

class OtherProjectile extends SpriteComponent with CollisionCallbacks, HasGameRef<skyfight> {
  final double speed;
  final Vector2 direction; // New direction property

  OtherProjectile({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
    required this.direction,
  }) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('torpedo_flame.png'); // Add a sprite for the projectile
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the projectile in the specified direction
    position += direction * speed * dt;

    // Remove if it goes off-screen
    if (position.x > gameRef.size.x || position.x < 0 || position.y > gameRef.size.y || position.y < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Destroy other planes on collision
    if (other is Plane) {
      removeFromParent();       // Remove the projectile
    }
  }
}
