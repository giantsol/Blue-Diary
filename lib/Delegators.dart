
import 'package:flutter/material.dart';

abstract class ShowBottomSheetDelegator {
  void showBottomSheet(Function(BuildContext) builder, {
    Function(dynamic) onClosed
  });
}

abstract class SetCurrentDrawerChildScreenItemDelegator {
  void setCurrentDrawerChildScreenItem(String key);
}

abstract class ShowSnackBarDelegator {
  void showSnackBar(Widget widget, {
    Duration duration,
  });
}

abstract class SettingsChangedListenerDelegator {
  void addSettingsChangedListener(void Function() listener);
  void removeSettingsChangedListener(void Function() listener);
}

abstract class WeekBlocDelegator implements
  ShowBottomSheetDelegator,
  SetCurrentDrawerChildScreenItemDelegator,
  ShowSnackBarDelegator,
  SettingsChangedListenerDelegator { }