
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class HomeUsecases {
  final PrefsRepository _prefsRepository;

  var _currentChildScreenItemKey = HomeChildScreenItem.KEY_RECORD;

  HomeUsecases(this._prefsRepository);

  List<HomeChildScreenItem> getNavigationItems() {
    final recordNavigationItem = HomeChildScreenItem(
      key: HomeChildScreenItem.KEY_RECORD,
      iconPath: _currentChildScreenItemKey == HomeChildScreenItem.KEY_RECORD ? 'assets/ic_record_activated.png'
        : 'assets/ic_record.png',
      titleColor: _currentChildScreenItemKey == HomeChildScreenItem.KEY_RECORD ? AppColors.PRIMARY
        : AppColors.TEXT_BLACK_LIGHT,
    );
    final journeyNavigationItem = HomeChildScreenItem(
      key: HomeChildScreenItem.KEY_JOURNEY,
      iconPath: _currentChildScreenItemKey == HomeChildScreenItem.KEY_JOURNEY ? 'assets/ic_record_activated.png'
        : 'assets/ic_record.png',
      titleColor: _currentChildScreenItemKey == HomeChildScreenItem.KEY_JOURNEY ? AppColors.PRIMARY
        : AppColors.TEXT_BLACK_LIGHT,
    );
    final rankingNavigationItem = HomeChildScreenItem(
      key: HomeChildScreenItem.KEY_RANKING,
      iconPath: _currentChildScreenItemKey == HomeChildScreenItem.KEY_RANKING ? 'assets/ic_record_activated.png'
        : 'assets/ic_record.png',
      titleColor: _currentChildScreenItemKey == HomeChildScreenItem.KEY_RANKING ? AppColors.PRIMARY
        : AppColors.TEXT_BLACK_LIGHT,
    );
    final settingsNavigationItem = HomeChildScreenItem(
      key: HomeChildScreenItem.KEY_SETTINGS,
      iconPath: _currentChildScreenItemKey == HomeChildScreenItem.KEY_SETTINGS ? 'assets/ic_settings_activated.png'
        : 'assets/ic_settings.png',
      titleColor: _currentChildScreenItemKey == HomeChildScreenItem.KEY_SETTINGS ? AppColors.PRIMARY
        : AppColors.TEXT_BLACK_LIGHT,
    );
    return [recordNavigationItem, journeyNavigationItem, rankingNavigationItem, settingsNavigationItem];
  }

  String getCurrentChildScreenKey() {
    return _currentChildScreenItemKey;
  }

  void setCurrentChildScreenKey(String key) {
    _currentChildScreenItemKey = key;
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }

  Future<bool> getUseLockScreen() async {
    return _prefsRepository.getUseLockScreen();
  }
}