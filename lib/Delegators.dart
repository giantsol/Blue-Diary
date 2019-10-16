
import 'package:flutter/material.dart';

abstract class ShowBottomSheetDelegator {
  void showBottomSheet(void Function(BuildContext) builder, {
    void Function() onClosed
  });
}

abstract class ShowSnackBarDelegator {
  void showSnackBar(String text, Duration duration);
}

abstract class SettingsChangedListenerDelegator {
  void addSettingsChangedListener(void Function() listener);
  void removeSettingsChangedListener(void Function() listener);
}

abstract class WeekBlocDelegator implements
  ShowBottomSheetDelegator,
  ShowSnackBarDelegator,
  SettingsChangedListenerDelegator { }