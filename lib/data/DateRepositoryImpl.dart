
import 'package:cloud_functions/cloud_functions.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';

class DateRepositoryImpl implements DateRepository {
  DateTime _today = DateRepository.INVALID_DATE;

  @override
  Future<DateTime> getToday() async {
    if (_today == DateRepository.INVALID_DATE) {
      try {
        final callable = CloudFunctions.instance.getHttpsCallable(functionName: 'getTodayInMillis');
        final result = await callable.call().timeout(const Duration(seconds: 10));
        final millis = result.data;
        _today = DateTime.fromMillisecondsSinceEpoch(millis);
      } catch (e) { }
    }
    return _today;
  }

  @override
  Future<bool> syncTodayWithServer() async {
    try {
      final callable = CloudFunctions.instance.getHttpsCallable(functionName: 'getTodayInMillis');
      final result = await callable.call().timeout(const Duration(seconds: 10));
      final millis = result.data;
      _today = DateTime.fromMillisecondsSinceEpoch(millis);
      return true;
    } catch (e) {
      return false;
    }
  }
}