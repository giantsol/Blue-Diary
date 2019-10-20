
import 'package:flutter/material.dart';

abstract class ShowBottomSheetDelegator {
  void showBottomSheet(void Function(BuildContext) builder, {
    void Function() onClosed
  });
}

abstract class ShowSnackBarDelegator {
  void showSnackBar(String text, Duration duration);
}

abstract class WeekBlocDelegator implements
  ShowBottomSheetDelegator,
  ShowSnackBarDelegator { }

abstract class SettingsBlocDelegator implements
  ShowBottomSheetDelegator,
  ShowSnackBarDelegator { }
