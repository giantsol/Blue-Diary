
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/usecase/GetDayMemoUsecase.dart';
import 'package:todo_app/domain/usecase/GetStreakCountUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/IsDayMarkedCompletedUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class GetWeekRecordUsecase {
  static final _enterRegex = RegExp(r'\n');

  final _prefsRepository = dependencies.prefsRepository;
  final _toDoRepository = dependencies.toDoRepository;
  final _memoRepository = dependencies.memoRepository;

  final _getTodayUsecase = GetTodayUsecase();
  final _getDayMemoUsecase = GetDayMemoUsecase();
  final _isDayMarkedCompletedUsecase = IsDayMarkedCompletedUsecase();
  final _getStreakCountUsecase = GetStreakCountUsecase();

  Future<WeekRecord> invoke(DateTime date) async {
    final today = await _getTodayUsecase.invoke();
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
      final memo = await _getDayMemoUsecase.invoke(date);

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
      final currentDayStreak = await _getStreakCountUsecase.invoke(date);
      final prevDayStreak = await _getStreakCountUsecase.invoke(date.subtract(const Duration(days: 1)));
      final nextDayStreak = await _getStreakCountUsecase.invoke(date.add(const Duration(days: 1)));
      final allToDosDone = toDos.length > 0 && toDos.every((it) => it.isDone);
      final isLightColor = !allToDosDone && today.compareTo(date) > 0;
      final isTopLineVisible = (currentDayStreak >= 2) || (prevDayStreak >= 1 && currentDayStreak == 0 && isToday);
      final isTopLineLightColorIfVisible = currentDayStreak < 1;
      final isBottomLineVisible = (currentDayStreak >= 1 && nextDayStreak > currentDayStreak) || (currentDayStreak >= 1 && nextDayStreak == 0 && today.difference(date).inDays == 1);
      final isBottomLineLightColorIfVisible = nextDayStreak <= currentDayStreak;

      // whether to show mark completed icon
      final firstLaunchDate = DateTime.parse(await _prefsRepository.getFirstLaunchDateString());
      final hasBeenMarkedCompleted = await _isDayMarkedCompletedUsecase.invoke(date);
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
}