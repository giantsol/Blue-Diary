
import 'package:todo_app/data/home/HomeRepositoryImpl.dart';
import 'package:todo_app/domain/home/HomeUsecases.dart';

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(HomeRepositoryImpl());
}