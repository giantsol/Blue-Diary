
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';

class RecordStateV2 {
  final String year;
  final String monthAndNthWeek;
  final List<WeekRecord> weekRecords;

  const RecordStateV2({
    this.year,
    this.monthAndNthWeek,
    this.weekRecords = const [],
  });

  static RecordStateV2 createTestState() {
    return RecordStateV2(
      year: '2019',
      monthAndNthWeek: '9월 셋째주',
      weekRecords: [
        WeekRecord(
          isCheckPointsLocked: false,
          checkPoints: [
            CheckPoint(bulletPointNumber: 1, text: '', hintText: '이건 힌트 텍스트 입니다.'),
            CheckPoint(bulletPointNumber: 2, text: 'ㄷㄹㄷㄹ'),
            CheckPoint(bulletPointNumber: 3, text: '나나나나ㅏ나나나나나나나나나나ㅏ나나나나나나나'),
          ],
          dayPreviews: [
            DayPreview(thumbnailString: 'Mon', title: '9월 1일', totalToDosCount: 0, doneToDosCount: 0, isLocked: false, hasTrailingDots: true, isToday: true),
            DayPreview(thumbnailString: 'Tue', title: '9월 2일', totalToDosCount: 4, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Wed', title: '9월 3일', totalToDosCount: 4, doneToDosCount: 1, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Thu', title: '9월 4일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Fri', title: '9월 5일', totalToDosCount: 4, doneToDosCount: 4, isLocked: true, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sat', title: '9월 6일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sun', title: '9월 7일', totalToDosCount: 4, doneToDosCount: 3, isLocked: false, hasTrailingDots: false),
          ],
        ),
        WeekRecord(
          isCheckPointsLocked: true,
          checkPoints: [
            CheckPoint(bulletPointNumber: 1, text: '2페이지', hintText: '이건 힌트 텍스트 입니다.'),
            CheckPoint(bulletPointNumber: 2, text: '덜덜'),
            CheckPoint(bulletPointNumber: 3, text: '헬로우'),
          ],
          dayPreviews: [
            DayPreview(thumbnailString: 'Mon', title: '9월 8일', totalToDosCount: 0, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Tue', title: '9월 9일', totalToDosCount: 4, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Wed', title: '9월 10일', totalToDosCount: 8, doneToDosCount: 1, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Thu', title: '9월 11일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Fri', title: '9월 12일', totalToDosCount: 8, doneToDosCount: 3, isLocked: true, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sat', title: '9월 13일', totalToDosCount: 16, doneToDosCount: 3, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sun', title: '9월 14일', totalToDosCount: 4, doneToDosCount: 3, isLocked: false, hasTrailingDots: false),
          ],
        ),
        WeekRecord(
          isCheckPointsLocked: false,
          checkPoints: [
            CheckPoint(bulletPointNumber: 1, text: '모름', hintText: '이건 힌트 텍스트 입니다.'),
            CheckPoint(bulletPointNumber: 2, text: '', hintText: '힌트 텍스트 3'),
            CheckPoint(bulletPointNumber: 3, text: '나나나나ㅏ나나나나나나나나나나ㅏ나나나나나나나'),
          ],
          dayPreviews: [
            DayPreview(thumbnailString: 'Mon', title: '9월 15일', totalToDosCount: 0, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Tue', title: '9월 16일', totalToDosCount: 4, doneToDosCount: 0, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Wed', title: '9월 17일', totalToDosCount: 4, doneToDosCount: 1, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Thu', title: '9월 18일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Fri', title: '9월 19일', totalToDosCount: 4, doneToDosCount: 4, isLocked: true, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sat', title: '9월 20일', totalToDosCount: 4, doneToDosCount: 4, isLocked: false, hasTrailingDots: true),
            DayPreview(thumbnailString: 'Sun', title: '9월 21일', totalToDosCount: 4, doneToDosCount: 3, isLocked: false, hasTrailingDots: false),
          ],
        ),
      ],
    );
  }

  RecordStateV2 buildNew({
    String year,
    String monthAndNthWeek,
    List<WeekRecord> weekRecords,
  }) {
    return RecordStateV2(
      year: year ?? this.year,
      monthAndNthWeek: monthAndNthWeek ?? this.monthAndNthWeek,
      weekRecords: weekRecords ?? this.weekRecords,
    );
  }
}