
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class SetCategoryUsecase {
  final CategoryRepository _categoryRepository;

  SetCategoryUsecase(this._categoryRepository);

  Future<int> invoke(Category category) {
    return _categoryRepository.setCategory(category);
  }
}