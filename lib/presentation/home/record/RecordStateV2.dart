
import 'package:todo_app/domain/entity/CheckPoint.dart';

class RecordStateV2 {
  final String year;
  final String monthAndNthWeek;
  final bool isCheckPointsLocked;
  final List<CheckPoint> checkPoints;

  const RecordStateV2({
    this.year,
    this.monthAndNthWeek,
    this.isCheckPointsLocked = false,
    this.checkPoints = const [],
  });

  static RecordStateV2 createTestState() {
    return RecordStateV2(
      year: '2019',
      monthAndNthWeek: '9월 셋째주',
      isCheckPointsLocked: false,
      checkPoints: [
        CheckPoint(bulletPointNumber: 1, hintText: '이건 힌트 텍스트 입니다.'),
        CheckPoint(bulletPointNumber: 2, text: 'ㄷㄹㄷㄹ'),
        CheckPoint(bulletPointNumber: 3, text: '나나나나ㅏ나나나나나나나나나나ㅏ나나나나나나나'),
      ]
    );
  }

  RecordStateV2 buildNew({
    String year,
    String monthAndNthWeek,
    bool isCheckPointsLocked,
    List<CheckPoint> checkPoints,
  }) {
    return RecordStateV2(
      year: year ?? this.year,
      monthAndNthWeek: monthAndNthWeek ?? this.monthAndNthWeek,
      isCheckPointsLocked: isCheckPointsLocked ?? this.isCheckPointsLocked,
      checkPoints: checkPoints ?? this.checkPoints,
    );
  }
}