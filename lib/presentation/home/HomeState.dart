
import 'package:todo_app/domain/entity/BottomNavigationItem.dart';

class HomeState {
  final List<BottomNavigationItem> navigationItems;
  final String currentChildScreenKey;

  const HomeState({
    this.navigationItems = const [],
    this.currentChildScreenKey,
  });

  HomeState buildNew({
    List<BottomNavigationItem> navigationItems,
    String currentChildScreenKey,
  }) {
    return HomeState(
      navigationItems: navigationItems ?? this.navigationItems,
      currentChildScreenKey: currentChildScreenKey ?? this.currentChildScreenKey,
    );
  }

}

