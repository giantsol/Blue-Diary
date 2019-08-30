
import 'package:todo_app/data/home/HomeRepositoryImpl.dart';
import 'package:todo_app/data/home/record/RecordRepositoryImpl.dart';
import 'package:todo_app/domain/home/HomeRepository.dart';
import 'package:todo_app/domain/home/HomeUsecases.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/RecordUsecases.dart';

final HomeRepository _homeRepository = HomeRepositoryImpl();
final RecordRepository _recordRepository = RecordRepositoryImpl();

class Dependencies {
  final HomeUsecases homeUsecases = HomeUsecases(_homeRepository);
  final RecordUsecases recordUsecases = RecordUsecases(_recordRepository, _homeRepository);
}