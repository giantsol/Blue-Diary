
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';

class WeekRecord {
  final bool isCheckPointsLocked;
  final List<CheckPoint> checkPoints;
  final List<DayPreview> dayPreviews;

  const WeekRecord(this.isCheckPointsLocked, this.checkPoints, this.dayPreviews);
}