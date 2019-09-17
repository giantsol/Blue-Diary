// HomeScreen의 drawer에 들어가는 모든 DrawerItem의 상위 interface
abstract class DrawerItem { }

class DrawerHeaderItem implements DrawerItem {
  final String title;

  const DrawerHeaderItem(this.title);
}

// 기록, 달력 등 같이 HomeScreen에 들어가는 child screen들
class DrawerChildScreenItem implements DrawerItem {
  static const KEY_RECORD = 'record';
  static const KEY_CALENDAR = 'calendar';
  static const KEY_STATISTICS = 'statistics';

  final String key;
  final String title;
  final bool isSelected;
  final bool isEnabled;

  const DrawerChildScreenItem(this.key, this.title, {
    this.isSelected = false,
    this.isEnabled = true,
  });

  DrawerChildScreenItem buildNew({
    String title,
    bool isSelected,
    bool isEnabled
  }) {
    return DrawerChildScreenItem(this.key,
      title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
      isEnabled: isEnabled ?? this.isEnabled);
  }
}

// HomeScreen과 같은 레벨의 다른 screen들
class DrawerScreenItem implements DrawerItem {
  static const KEY_SETTINGS = 'settings';
  static const KEY_ABOUT = 'about';
  static const KEY_REPORT_BUG = 'report-bug';

  final String key;
  final String title;
  final bool isEnabled;

  const DrawerScreenItem(this.key, this.title, {
    this.isEnabled = true,
  });

  DrawerScreenItem buildNew({
    String title,
    bool isEnabled,
  }) {
    return DrawerScreenItem(this.key, title ?? this.title,
      isEnabled: isEnabled ?? this.isEnabled);
  }
}

// DrawerItem 사이에 있는 공백.. 단순 UI 표현용
class DrawerSpacerItem implements DrawerItem { }
