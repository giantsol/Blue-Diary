
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
    final checkPoints = await _memoRepository.getCheckPoints(date);
    bool containsToday = false;

    final datesInWeek = Utils.getDatesInWeek(date);
    List<DayPreview> dayPreviews = [];
    // used for calculating whether to draw lines above/below the circle
    bool prevDayCompleted = false;
    bool curDayCompleted = false;

    for (int i = 0; i < datesInWeek.length; i++) {
      final date = datesInWeek[i];
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

      curDayCompleted = toDos.length > 0 && toDos.length == toDos.where((toDo) => toDo.isDone).length;

      final isToday = Utils.isSameDay(date, today);
      containsToday = containsToday || isToday;

      final dayPreview = DayPreview(
        year: date.year,
        month: date.month,
        day: date.day,
        weekday: date.weekday,
        totalToDosCount: toDos.length,
        doneToDosCount: toDos.where((it) => it.isDone).length,
        isToday: isToday,
        isLightColor: !curDayCompleted && today.compareTo(date) > 0,
        isTopLineVisible: (curDayCompleted && prevDayCompleted) || (date == today && prevDayCompleted),
        isTopLineLightColor: !curDayCompleted,
        memoPreview: memo.text.length > 0 ? memo.text.replaceAll(_enterRegex, ', ') : '',
        toDoPreviews: toDos.length > 2 ? toDos.sublist(0, 2) : toDos,
      );

      dayPreviews.add(dayPreview);

      if (i > 0) {
        dayPreviews[i - 1] = dayPreviews[i - 1].buildNew(
          isBottomLineVisible: (prevDayCompleted && curDayCompleted) || (date == today && prevDayCompleted),
          isBottomLineLightColor: !curDayCompleted,
        );
      }

      prevDayCompleted = curDayCompleted;
    }

    return WeekRecord(
      dateInWeek: dateInWeek,
      checkPoints: checkPoints,
      dayPreviews: dayPreviews,
      containsToday: containsToday,
    );
  }

  void setCheckPoint(CheckPoint checkPoint) {
    _memoRepository.setCheckPoint(checkPoint);
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }

  Future<bool> hasShownWeekScreenTutorial() async {
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

  Future<DateTime> getFirstLaunchDate() async {
    final useReal = await _prefsRepository.getUseRealFirstLaunchDate();
    if (useReal) {
      return DateTime.parse(await _prefsRepository.getRealFirstLaunchDateString());
    } else {
      return DateTime.parse(await _prefsRepository.getCustomFirstLaunchDateString());
    }
  }
}