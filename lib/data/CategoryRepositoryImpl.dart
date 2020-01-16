
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _database;

  const CategoryRepositoryImpl(this._database);

  @override
  Future<Category> getCategory(int id) {
    return _database.getCategory(id);
  }

  @override
  Future<int> setCategory(Category category) {
    return _database.setCategory(category);
  }

  @override
  Future<List<Category>> getAllCategories() {
    return _database.getAllCategories();
  }

  @override
  Future<void> removeCategory(Category category) {
    return _database.removeCategory(category);
  }
}