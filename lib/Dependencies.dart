
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/data/CategoryRepositoryImpl.dart';
import 'package:todo_app/data/DateRepositoryImpl.dart';
import 'package:todo_app/data/MemoRepositoryImpl.dart';
import 'package:todo_app/data/NotificationRepositoryImpl.dart';
import 'package:todo_app/data/PetRepositoryImpl.dart';
import 'package:todo_app/data/PrefsRepositoryImpl.dart';
import 'package:todo_app/data/RankingRepositoryImpl.dart';
import 'package:todo_app/data/ToDoRepositoryImpl.dart';
import 'package:todo_app/data/UserRepositoryImpl.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/NotificationRepository.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

final AppDatabase _database = AppDatabase();
final AppPreferences _prefs = AppPreferences();

class Dependencies {
  final PrefsRepository prefsRepository = PrefsRepositoryImpl(_prefs);
  final DateRepository dateRepository = DateRepositoryImpl();
  final ToDoRepository toDoRepository = ToDoRepositoryImpl(_database);
  final CategoryRepository categoryRepository = CategoryRepositoryImpl(_database);
  final MemoRepository memoRepository = MemoRepositoryImpl(_database);
  final PetRepository petRepository = PetRepositoryImpl(_database, _prefs);
  final UserRepository userRepository = UserRepositoryImpl();
  final RankingRepository rankingRepository = RankingRepositoryImpl();
  final NotificationRepository notificationRepository = NotificationRepositoryImpl(_database, _prefs);
}