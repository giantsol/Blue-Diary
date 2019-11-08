
import 'package:todo_app/domain/entity/Friend.dart';

class WorldState {
  final String worldKey;
  final String bgPath;
  final int growthPainCount;
  final List<Friend> friends;

  const WorldState({
    this.worldKey = '',
    this.bgPath = '',
    this.growthPainCount = 0,
    this.friends = const [],
  });

  WorldState buildNew({
    String worldKey,
    String bgPath,
    int growthPainCount,
    List<Friend> friends,
  }) {
    return WorldState(
      worldKey: worldKey ?? this.worldKey,
      bgPath: bgPath ?? this.bgPath,
      growthPainCount: growthPainCount ?? this.growthPainCount,
      friends: friends ?? this.friends,
    );
  }
}