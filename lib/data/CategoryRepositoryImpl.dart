
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  const CategoryRepositoryImpl(this._db);

  @override
  Future<Category> getCategory(int id) async {
    return _db.getCategory(id);
  }

  @override
  Future<int> setCategory(Category category) async {
    return _db.setCategory(category);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return _db.getAllCategories();
  }
}