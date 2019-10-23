
import 'package:todo_app/data/datasource/CategoryDataSource.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;

  const CategoryRepositoryImpl(this._dataSource);

  @override
  Future<Category> getCategory(int id) {
    return _dataSource.getCategory(id);
  }

  @override
  Future<int> setCategory(Category category) {
    return _dataSource.setCategory(category);
  }

  @override
  Future<List<Category>> getAllCategories() {
    return _dataSource.getAllCategories();
  }

  @override
  Future<void> removeCategory(Category category) {
    return _dataSource.removeCategory(category);
  }
}