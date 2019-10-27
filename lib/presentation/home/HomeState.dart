
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';

class HomeState {
  final List<HomeChildScreenItem> childScreenItems;
  final String currentChildScreenKey;

  const HomeState({
    this.childScreenItems = const [],
    this.currentChildScreenKey = '',
  });

  HomeState buildNew({
    List<HomeChildScreenItem> childScreenItems,
    String currentChildScreenKey,
  }) {
    return HomeState(
      childScreenItems: childScreenItems ?? this.childScreenItems,
      currentChildScreenKey: currentChildScreenKey ?? this.currentChildScreenKey,
    );
  }
}

