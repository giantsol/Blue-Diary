
import 'package:todo_app/domain/entity/Category.dart';

abstract class CategoryRepository {
  Future<Category> getCategory(int id);
  Future<int> setCategory(Category category);
  Future<List<Category>> getAllCategories();
}