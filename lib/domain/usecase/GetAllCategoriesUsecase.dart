
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/presentation/App.dart';

class GetAllCategoriesUsecase {
  final _categoryRepository = dependencies.categoryRepository;

  Future<List<Category>> invoke() {
    return _categoryRepository.getAllCategories();
  }
}