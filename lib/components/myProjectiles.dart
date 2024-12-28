import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/game.dart';

import 'otherPlanes.dart';

class Projectile extends SpriteComponent with CollisionCallbacks, HasGameRef<skyfight> {
  final double speed;

  Projectile(Vector2 position, Vector2 size, this.speed)
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('fire_ball_blue.png'); // Add a sprite for the projectile
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the projectile forward
    position.x += speed * dt;

    // Remove if it goes off-screen
    if (position.x > gameRef.size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Destroy other planes on collision
    if (other is OtherPlanes) {
      removeFromParent(); // Remove the projectile as well
      other.removeFromParent();
      other.explode();
      //other.takeDamage(1);
    }
  }
}
