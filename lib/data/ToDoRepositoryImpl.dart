
import 'package:todo_app/data/datasource/ToDoDataSource.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final ToDoDataSource _dataSource;

  const ToDoRepositoryImpl(this._dataSource);

  @override
  Future<List<ToDo>> getToDos(DateTime date) async {
    return await _dataSource.getToDos(date);
  }

  @override
  void setToDo(ToDo toDo) {
    _dataSource.setToDo(toDo);
  }

  @override
  void removeToDo(ToDo toDo) {
    _dataSource.removeToDo(toDo);
  }

}