
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/presentation/App.dart';

class SetCategoryUsecase {
  final _categoryRepository = dependencies.categoryRepository;

  Future<int> invoke(Category category) {
    return _categoryRepository.setCategory(category);
  }
}