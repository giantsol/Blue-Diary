
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/presentation/App.dart';

class RemoveCategoryUsecase {
  final _categoryRepository = dependencies.categoryRepository;

  Future<void> invoke(Category category) {
    return _categoryRepository.removeCategory(category);
  }
}