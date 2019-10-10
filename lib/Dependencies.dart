
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/data/CategoryRepositoryImpl.dart';
import 'package:todo_app/data/DateRepositoryImpl.dart';
import 'package:todo_app/data/DrawerRepositoryImpl.dart';
import 'package:todo_app/data/LockRepositoryImpl.dart';
import 'package:todo_app/data/MemoRepositoryImpl.dart';
import 'package:todo_app/data/PrefsRepositoryImpl.dart';
import 'package:todo_app/data/ToDoRepositoryImpl.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/DrawerRepository.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/CreatePasswordUsecases.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/domain/usecase/HomeUsecases.dart';
import 'package:todo_app/domain/usecase/InputPasswordUsecases.dart';
import 'package:todo_app/domain/usecase/SettingsUsecases.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';

final AppDatabase _database = AppDatabase();
final AppPreferences _prefs = AppPreferences();
final DrawerRepository _drawerRepository = DrawerRepositoryImpl();
final MemoRepository _memoRepository = MemoRepositoryImpl(_database);
final DateRepository _dateRepository = DateRepositoryImpl();
final ToDoRepository _toDoRepository = ToDoRepositoryImpl(_database);
final LockRepository _lockRepository = LockRepositoryImpl(_database);
final PrefsRepository _prefsRepository = PrefsRepositoryImpl(_prefs);
final CategoryRepository _categoryRepository = CategoryRepositoryImpl(_database);

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(_drawerRepository);
  final WeekUsecases weekUsecases = WeekUsecases(_memoRepository, _dateRepository, _toDoRepository, _lockRepository, _prefsRepository);
  final CreatePasswordUsecases createPasswordUsecases = CreatePasswordUsecases(_prefsRepository);
  final InputPasswordUsecases inputPasswordUsecases = InputPasswordUsecases(_prefsRepository);
  final DayUsecases dayUsecases = DayUsecases(_toDoRepository, _categoryRepository, _memoRepository);
  final SettingsUsecases settingsUsecases = SettingsUsecases(_prefsRepository);
}