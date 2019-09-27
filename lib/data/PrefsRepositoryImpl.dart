
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class PrefsRepositoryImpl implements PrefsRepository {
  final AppPreferences _prefs;

  const PrefsRepositoryImpl(this._prefs);

  @override
  Future<String> getUserPassword() async {
    return _prefs.getUserPassword();
  }

  @override
  Future<bool> setUserPassword(String password) async {
    return _prefs.setUserPassword(password);
  }

}