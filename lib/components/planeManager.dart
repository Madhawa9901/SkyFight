import 'package:flame/components.dart';
import 'package:game/game.dart';
import 'dart:math';
import '../constant.dart';
import 'otherPlanes.dart';

class PlaneManager extends Component with HasGameRef<skyfight> {
  double planeSpawnTimer = 0;

  @override
  void update(double dt) {
    planeSpawnTimer += dt;

    if(planeSpawnTimer > planeInterval) {
      planeSpawnTimer = 0;
      spawnPlane();
    }
  }

  void spawnPlane() {
    // Set the spawn position at the right edge of the screen
    final double xPosition = gameRef.size.x; // Start at the far right
    final double yPosition = Random().nextDouble() * (gameRef.size.y - 150); // Random Y position within screen bounds

    // Set size of the planes
    final Vector2 planeSize = Vector2(50, 50);

    // Create the plane using the OtherPlanes class
    final plane = OtherPlanes(
      Vector2(xPosition, yPosition), // Position of the plane
      planeSize, // Size of the plane
    );

    // Add the plane to the game
    add(plane);
  }
}