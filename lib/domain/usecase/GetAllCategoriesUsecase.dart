
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository _categoryRepository;

  GetAllCategoriesUsecase(this._categoryRepository);

  Future<List<Category>> invoke() {
    return _categoryRepository.getAllCategories();
  }
}