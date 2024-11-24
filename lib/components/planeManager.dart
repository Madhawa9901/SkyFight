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

    if (planeSpawnTimer > getAdjustedInterval()) {
      planeSpawnTimer = 0;
      spawnPlane();
    }
  }

  double getAdjustedInterval() {
    return max(0.5, planeInterval - (gameRef.score * 0.01));
  }

  void spawnPlane() {
    if (gameRef.children.whereType<OtherPlanes>().length >= 5) return;

    final double xPosition = gameRef.size.x;
    final double yPosition = Random().nextDouble() * (gameRef.size.y - 150);
    final Vector2 randomSize = Vector2(
      Random().nextDouble() * 30 + 30,
      Random().nextDouble() * 30 + 30,
    );

    final plane = OtherPlanes(Vector2(xPosition, yPosition), randomSize);
    add(plane);
  }
}
