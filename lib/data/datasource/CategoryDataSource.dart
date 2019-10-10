
import 'package:todo_app/domain/entity/Category.dart';

abstract class CategoryDataSource {
  Future<Category> getCategory(int id);
  Future<List<Category>> getAllCategories();
  Future<int> setCategory(Category category);
  Future<void> removeCategory(Category category);
}