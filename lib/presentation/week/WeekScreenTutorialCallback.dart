
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';

abstract class WeekScreenTutorialCallback {
  ViewLayoutInfo Function() getHeaderFinder();
  Future<void> scrollToCheckPoints();
  ViewLayoutInfo Function() getCheckPointsFinder();
  Future<void> scrollToTodayPreview();
  ViewLayoutInfo Function() getTodayPreviewFinder();
  Future<void> scrollToFirstCompletableDayPreview();
  ViewLayoutInfo Function() getFirstCompletableDayPreviewFinder();
}
