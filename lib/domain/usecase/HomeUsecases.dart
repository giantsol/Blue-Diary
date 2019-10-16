
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/BottomNavigationItem.dart';

class HomeUsecases {
  var _currentNavigationItemIndex = 0;

  List<BottomNavigationItem> getNavigationItems() {
    final recordNavigationItem = BottomNavigationItem(
      key: BottomNavigationItem.KEY_RECORD,
      iconPath: _currentNavigationItemIndex == 0 ? 'assets/ic_record_activated.png' : 'assets/ic_record.png',
      titleColor: _currentNavigationItemIndex == 0 ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
    );
    final settingsNavigationItem = BottomNavigationItem(
      key: BottomNavigationItem.KEY_SETTINGS,
      iconPath: _currentNavigationItemIndex == 1 ? 'assets/ic_settings_activated.png' : 'assets/ic_settings.png',
      titleColor: _currentNavigationItemIndex == 1 ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
    );
    return [recordNavigationItem, settingsNavigationItem];
  }

  String getCurrentChildScreenKey() {
    return _currentNavigationItemIndex == 0 ? BottomNavigationItem.KEY_RECORD
      : BottomNavigationItem.KEY_SETTINGS;
  }
}