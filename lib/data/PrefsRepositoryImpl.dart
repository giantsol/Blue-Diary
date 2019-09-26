
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class PrefRepositoryImpl implements PrefRepository {
  final AppPreferences _prefs;

  const PrefRepositoryImpl(this._prefs);

  @override
  Future<String> getUserPassword() async {
    return _prefs.getUserPassword();
  }

}