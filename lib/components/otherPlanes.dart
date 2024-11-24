import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/constant.dart';
import 'package:game/game.dart';

import 'otherProjectiles.dart';

class OtherPlanes extends SpriteComponent with CollisionCallbacks, HasGameRef<skyfight> {
  double fireCooldown = Random().nextDouble() * 2 + 1;
  double fireTimer = 0;
  int health = 3;

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
    return (position.y - playerPlane.position.y).abs() < size.y * 1.5;
  }

  void fireProjectile() {
    final randomSpeed = Random().nextDouble() * (450 - 250) + 250; // Random speed between 250 and 450
    final projectile = OtherProjectile(
      position: position.clone(),
      size: Vector2(15, 10),
      speed: randomSpeed,
      direction: Vector2(-1, 0),
    );
    gameRef.add(projectile);
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      explode();
    }
  }

  void explode() async {
    final List<String> explosionSprites = [
      'explosion_01.png',
      'explosion_02.png',
      'explosion_03.png',
      'explosion_04.png',
      'explosion_05.png',
      'explosion_06.png',
      'explosion_07.png',
      'explosion_08.png',
      'explosion_09.png',
    ];

    final explosion = SpriteComponent(
      position: position.clone(),
      size: size.clone(),
    );

    explosion.sprite = await gameRef.loadSprite(explosionSprites[0]);

    gameRef.add(explosion);

    int currentFrame = 0;

    // Loop through the explosion frames
    for (int i = 1; i < explosionSprites.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () async {
        explosion.sprite = await gameRef.loadSprite(explosionSprites[i]);
      });
    }

    // After the last frame, remove the explosion and trigger score increment
    explosion.removeFromParent();
    gameRef.incrementScore();

    removeFromParent(); // Remove the object that triggered the explosion
  }
}