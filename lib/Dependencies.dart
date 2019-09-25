
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/data/DateRepositoryImpl.dart';
import 'package:todo_app/data/DrawerRepositoryImpl.dart';
import 'package:todo_app/data/LockRepositoryImpl.dart';
import 'package:todo_app/data/MemoRepositoryImpl.dart';
import 'package:todo_app/data/ToDoRepositoryImpl.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/DrawerRepository.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/HomeUsecases.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';

final AppDatabase _database = AppDatabase();
final DrawerRepository _drawerRepository = DrawerRepositoryImpl();
final MemoRepository _memoRepository = MemoRepositoryImpl(_database);
final DateRepository _dateRepository = DateRepositoryImpl();
final ToDoRepository _toDoRepository = TodoRepositoryImpl(_database);
final LockRepository _lockRepository = LockRepositoryImpl(_database);

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(_drawerRepository);
  final WeekUsecases weekUsecases = WeekUsecases(_memoRepository, _dateRepository, _toDoRepository, _lockRepository);
}