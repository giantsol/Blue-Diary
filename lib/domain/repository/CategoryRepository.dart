
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class CategoryRepository {
  Future<Category> getCategory(ToDo toDo);
}