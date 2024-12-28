import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

import 'otherPlanes.dart';

class OtherProjectile extends SpriteComponent with CollisionCallbacks, HasGameRef<skyfight> {
  final double speed;
  final Vector2 direction;

  OtherProjectile({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
    required this.direction,
  }) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('torpedo_flame.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += direction * speed * dt;

    if (position.x > gameRef.size.x || position.x < 0 || position.y > gameRef.size.y || position.y < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Plane) {
      removeFromParent();
    }
  }
}
