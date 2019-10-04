
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  const CategoryRepositoryImpl(this._db);

  @override
  Future<Category> getCategory(ToDo toDo) async {
    return _db.getCategory(toDo);
  }
}