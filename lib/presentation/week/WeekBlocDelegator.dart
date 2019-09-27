
import 'package:flutter/cupertino.dart';

abstract class WeekBlocDelegator {
  void updateCurrentDrawerChildScreenItem(String key);
  void showBottomSheet(Function(BuildContext) builder, Function(dynamic) onClosed);
}
