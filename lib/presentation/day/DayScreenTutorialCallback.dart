
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';

abstract class DayScreenTutorialCallback {
  ViewLayoutInfo Function() getHeaderFinder();
  ViewLayoutInfo Function() getMemoFinder();
  ViewLayoutInfo Function() getAddToDoFinder();
}
