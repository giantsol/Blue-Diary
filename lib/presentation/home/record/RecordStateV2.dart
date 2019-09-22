
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';

class RecordStateV2 {
  final String year;
  final String monthAndNthWeek;
  final bool isCheckPointsLocked;
  final List<CheckPoint> checkPoints;
  final List<DayPreview> dayPreviews;

  const RecordStateV2({
    this.year,
    this.monthAndNthWeek,
    this.isCheckPointsLocked = false,
    this.checkPoints = const [],
    this.dayPreviews = const [],
  });

  static RecordStateV2 createTestState() {
    return RecordStateV2(
      year: '2019',
      monthAndNthWeek: '9월 셋째주',
      isCheckPointsLocked: true,
      checkPoints: [
        CheckPoint(bulletPointNumber: 1, text: '', hintText: '이건 힌트 텍스트 입니다.'),
        CheckPoint(bulletPointNumber: 2, text: 'ㄷㄹㄷㄹ'),
        CheckPoint(bulletPointNumber: 3, text: '나나나나ㅏ나나나나나나나나나나ㅏ나나나나나나나'),
      ],
      dayPreviews: [
        DayPreview(thumbnailString: 'Mon', title: '9월 1일', totalToDosCount: 0, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Tue', title: '9월 2일', totalToDosCount: 4, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Wed', title: '9월 3일', totalToDosCount: 4, doneToDosCount: 1, isLocked: false, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Thu', title: '9월 4일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Fri', title: '9월 5일', totalToDosCount: 4, doneToDosCount: 4, isLocked: true, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Sat', title: '9월 6일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
        DayPreview(thumbnailString: 'Sun', title: '9월 7일', totalToDosCount: 4, doneToDosCount: 3, isLocked: false, hasTrailingDots: false),
      ],
    );
  }

  RecordStateV2 buildNew({
    String year,
    String monthAndNthWeek,
    bool isCheckPointsLocked,
    List<CheckPoint> checkPoints,
    List<DayPreview> dayPreviews,
  }) {
    return RecordStateV2(
      year: year ?? this.year,
      monthAndNthWeek: monthAndNthWeek ?? this.monthAndNthWeek,
      isCheckPointsLocked: isCheckPointsLocked ?? this.isCheckPointsLocked,
      checkPoints: checkPoints ?? this.checkPoints,
      dayPreviews: dayPreviews ?? this.dayPreviews,
    );
  }
}