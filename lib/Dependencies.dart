
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/data/CategoryRepositoryImpl.dart';
import 'package:todo_app/data/DateRepositoryImpl.dart';
import 'package:todo_app/data/MemoRepositoryImpl.dart';
import 'package:todo_app/data/PetRepositoryImpl.dart';
import 'package:todo_app/data/PrefsRepositoryImpl.dart';
import 'package:todo_app/data/RankingRepositoryImpl.dart';
import 'package:todo_app/data/ToDoRepositoryImpl.dart';
import 'package:todo_app/data/UserRepositoryImpl.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';
import 'package:todo_app/domain/usecase/CreatePasswordUsecases.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/domain/usecase/HomeUsecases.dart';
import 'package:todo_app/domain/usecase/InputPasswordUsecases.dart';
import 'package:todo_app/domain/usecase/LockUsecases.dart';
import 'package:todo_app/domain/usecase/PetUsecases.dart';
import 'package:todo_app/domain/usecase/RankingUsecases.dart';
import 'package:todo_app/domain/usecase/SettingsUsecases.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';

final AppDatabase _database = AppDatabase();
final AppPreferences _prefs = AppPreferences();
final MemoRepository _memoRepository = MemoRepositoryImpl(_database);
final DateRepository _dateRepository = DateRepositoryImpl();
final ToDoRepository _toDoRepository = ToDoRepositoryImpl(_database);
final PrefsRepository _prefsRepository = PrefsRepositoryImpl(_prefs);
final CategoryRepository _categoryRepository = CategoryRepositoryImpl(_database);
final UserRepository _userRepository = UserRepositoryImpl();
final PetRepository _petRepository = PetRepositoryImpl(_database, _prefs);
final RankingRepository _rankingRepository = RankingRepositoryImpl();

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(_prefsRepository);
  final WeekUsecases weekUsecases = WeekUsecases(_memoRepository, _dateRepository, _toDoRepository, _prefsRepository);
  final CreatePasswordUsecases createPasswordUsecases = CreatePasswordUsecases(_prefsRepository);
  final InputPasswordUsecases inputPasswordUsecases = InputPasswordUsecases(_prefsRepository);
  final DayUsecases dayUsecases = DayUsecases(_toDoRepository, _categoryRepository, _memoRepository, _prefsRepository, _dateRepository);
  final SettingsUsecases settingsUsecases = SettingsUsecases(_prefsRepository);
  final LockUsecases lockUsecases = LockUsecases(_prefsRepository);
  final PetUsecases petUsecases = PetUsecases(_petRepository, _prefsRepository);
  final RankingUsecases rankingUsecases = RankingUsecases(_userRepository, _dateRepository, _prefsRepository, _toDoRepository, _rankingRepository, _petRepository);
}