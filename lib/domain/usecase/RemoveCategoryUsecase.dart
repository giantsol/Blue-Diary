
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';

class RemoveCategoryUsecase {
  final CategoryRepository _categoryRepository;

  RemoveCategoryUsecase(this._categoryRepository);

  Future<void> invoke(Category category) {
    return _categoryRepository.removeCategory(category);
  }
}