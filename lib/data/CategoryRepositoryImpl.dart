
import 'package:todo_app/data/datasource/CategoryDataSource.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;

  const CategoryRepositoryImpl(this._dataSource);

  @override
  Future<Category> getCategory(int id) async {
    return _dataSource.getCategory(id);
  }

  @override
  Future<int> setCategory(Category category) async {
    return _dataSource.setCategory(category);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return _dataSource.getAllCategories();
  }

  @override
  Future<void> removeCategory(Category category) async {
    return _dataSource.removeCategory(category);
  }
}