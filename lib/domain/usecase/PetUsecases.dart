
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class PetUsecases {
  final DateRepository _dateRepository;
  final PrefsRepository _prefsRepository;
  final ToDoRepository _toDoRepository;

  const PetUsecases(this._dateRepository, this._prefsRepository, this._toDoRepository);
}