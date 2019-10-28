
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';

abstract class WeekScreenViewFinders {
  ViewLayoutInfo Function() getPrevIconFinder();
  ViewLayoutInfo Function() getNextIconFinder();
  ViewLayoutInfo Function() getCheckPointsFinder();
  ViewLayoutInfo Function() getTodayPreviewFinder();
}
