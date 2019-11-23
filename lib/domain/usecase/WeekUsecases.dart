
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class WeekUsecases {
  static final _enterRegex = RegExp(r'\n');

  final MemoRepository _memoRepository;
  final DateRepository _dateRepository;
  final ToDoRepository _toDoRepository;
  final PrefsRepository _prefsRepository;

  const WeekUsecases(this._memoRepository, this._dateRepository, this._toDoRepository, this._prefsRepository);

  Future<DateTime> getToday() {
    return _dateRepository.getToday();
  }

  Future<WeekRecord> getWeekRecord(DateTime date) async {
    final today = await _dateRepository.getToday();
    final dateInWeek = DateInWeek.fromDate(date);
    final datesInWeek = Utils.getDatesInWeek(date);
    final hasShownFirstCompletableDayTutorial = await _prefsRepository.hasShownFirstCompletableDayTutorial();
    List<DayPreview> dayPreviews = [];
    bool containsToday = false;
    int firstCompletableDayTutorialIndex = -1;

    for (int i = 0; i < datesInWeek.length; i++) {
      final date = datesInWeek[i];
      final isToday = Utils.isSameDay(date, today);
      containsToday = containsToday || isToday;
      final toDos = await _toDoRepository.getToDos(date);
      final memo = await _memoRepository.getDayMemo(date);

      // bring undone todos to front
      toDos.sort((t1, t2) {
        if (t1.isDone && !t2.isDone) {
          return 1;
        } else if (!t1.isDone && t2.isDone){
          return -1;
        } else {
          return t1.order - t2.order;
        }
      });

      // whether to draw top and bottom lines
      final currentDayStreak = await _toDoRepository.getStreakCount(date);
      final prevDayStreak = await _toDoRepository.getStreakCount(date.subtract(const Duration(days: 1)));
      final nextDayStreak = await _toDoRepository.getStreakCount(date.add(const Duration(days: 1)));
      final allToDosDone = toDos.length > 0 && toDos.every((it) => it.isDone);
      final isLightColor = !allToDosDone && today.compareTo(date) > 0;
      final isTopLineVisible = (currentDayStreak >= 2) || (prevDayStreak >= 1 && currentDayStreak == 0 && isToday);
      final isTopLineLightColorIfVisible = currentDayStreak < 1;
      final isBottomLineVisible = (currentDayStreak >= 1 && nextDayStreak > currentDayStreak) || (currentDayStreak >= 1 && nextDayStreak == 0 && today.difference(date).inDays == 1);
      final isBottomLineLightColorIfVisible = nextDayStreak <= currentDayStreak;

      // whether to show mark completed icon
      final firstLaunchDate = DateTime.parse(await _prefsRepository.getFirstLaunchDateString());
      final hasBeenMarkedCompleted = await _toDoRepository.hasDayBeenMarkedCompleted(date);
      final canBeMarkedCompleted = allToDosDone && !hasBeenMarkedCompleted &&
        date.compareTo(firstLaunchDate) >= 0 && date.compareTo(today) <= 0;

      if (!hasShownFirstCompletableDayTutorial && firstCompletableDayTutorialIndex == -1 && canBeMarkedCompleted) {
        firstCompletableDayTutorialIndex = i;
      }

      final dayPreview = DayPreview(
        year: date.year,
        month: date.month,
        day: date.day,
        weekday: date.weekday,
        totalToDosCount: toDos.length,
        doneToDosCount: toDos.where((it) => it.isDone).length,
        isToday: isToday,
        isLightColor: isLightColor,
        isTopLineVisible: isTopLineVisible,
        isTopLineLightColor: isTopLineLightColorIfVisible,
        isBottomLineVisible: isBottomLineVisible,
        isBottomLineLightColor: isBottomLineLightColorIfVisible,
        memoPreview: memo.text.length > 0 ? memo.text.replaceAll(_enterRegex, ', ') : '',
        toDoPreviews: toDos.length > 2 ? toDos.sublist(0, 2) : toDos,
        canBeMarkedCompleted: canBeMarkedCompleted,
        isMarkedCompleted: currentDayStreak > 0,
        streakCount: currentDayStreak,
      );
      dayPreviews.add(dayPreview);
    }

    final checkPoints = await _memoRepository.getCheckPoints(date);

    return WeekRecord(
      dateInWeek: dateInWeek,
      checkPoints: checkPoints,
      dayPreviews: dayPreviews,
      containsToday: containsToday,
      firstCompletableDayTutorialIndex: firstCompletableDayTutorialIndex,
    );
  }

  void setCheckPoint(CheckPoint checkPoint) {
    _memoRepository.setCheckPoint(checkPoint);
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }

  Future<bool> hasShownWeekScreenTutorial() {
    return _prefsRepository.hasShownWeekScreenTutorial();
  }

  void setShownWeekScreenTutorial() {
    _prefsRepository.setShownWeekScreenTutorial();
  }

  Future<void> setRealFirstLaunchDateIfNotExists(DateTime date) async {
    final savedValue = await _prefsRepository.getRealFirstLaunchDateString();
    if (savedValue.isEmpty) {
      _prefsRepository.setRealFirstLaunchDate(date);
    }
  }

  Future<void> setDayMarkedCompleted(DateTime date) {
    return _toDoRepository.setDayMarkedCompleted(date);
  }

  Future<DateTime> getCompletedMarkableDayToKeepStreakBefore(DateTime date) async {
    final DateTime lastMarkedCompletedDay = await _toDoRepository.getLastMarkedCompletedDay(date.millisecondsSinceEpoch);
    if (lastMarkedCompletedDay != DateRepository.INVALID_DATE) {
      final nextOfLastMarkedCompletedDay = lastMarkedCompletedDay.add(const Duration(days: 1));
      if (nextOfLastMarkedCompletedDay.compareTo(date) >= 0) {
        return DateRepository.INVALID_DATE;
      } else {
        final toDos = await _toDoRepository.getToDos(nextOfLastMarkedCompletedDay);
        final allToDosDone = toDos.length > 0 && toDos.every((it) => it.isDone);
        if (allToDosDone) {
          return nextOfLastMarkedCompletedDay;
        } else {
          return DateRepository.INVALID_DATE;
        }
      }
    } else {
      return DateRepository.INVALID_DATE;
    }
  }

  void setShownFirstCompletableDayTutorial() {
    _prefsRepository.setShownFirstCompletableDayTutorial();
  }

  Future<int> getStreakCount(DateTime date) {
    return _toDoRepository.getStreakCount(date);
  }

  void addSeed(int count) {
    _prefsRepository.addSeed(count);
  }
}