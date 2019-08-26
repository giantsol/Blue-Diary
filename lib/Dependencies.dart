
import 'package:todo_app/data/home/HomeRepositoryImpl.dart';
import 'package:todo_app/data/home/record/RecordRepositoryImpl.dart';
import 'package:todo_app/domain/home/HomeUsecases.dart';
import 'package:todo_app/domain/home/record/RecordUsecases.dart';

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(HomeRepositoryImpl());
  final RecordUsecases recordUsecases = RecordUsecases(RecordRepositoryImpl());
}