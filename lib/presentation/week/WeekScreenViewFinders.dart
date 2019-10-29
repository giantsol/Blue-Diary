
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';

abstract class WeekScreenViewFinders {
  ViewLayoutInfo Function() getHeaderFinder();
  ViewLayoutInfo Function() getCheckPointsFinder();
  ViewLayoutInfo Function() getTodayPreviewFinder();
}
