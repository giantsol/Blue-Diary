
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  static const NEW_PASSWORD = "newPassword";
  static const CONFIRM_NEW_PASSWORD = "confirmNewPassword";
  static const CONFIRM_PASSWORD_FAIL = "confirmPasswordFail";
  static const CURRENT_PASSWORD = "currentPassword";
  static const RETRY_INPUT_PASSWORD = "retryInputPassword";
  static const CREATE_PASSWORD = "createPassword";
  static const CREATE_PASSWORD_BODY = "createPasswordBody";
  static const CREATE_PASSWORD_SUCCESS = "createPasswordSuccess";
  static const CREATE_PASSWORD_FAIL = "createPasswordFail";
  static const UNLOCK_FAIL = "unlockFail";
  static const PASSWORD_CHANGED = "passwordChanged";
  static const PASSWORD_UNCHANGED = "passwordUnchanged";
  static const CANCEL = "cancel";
  static const OK = "ok";
  static const ADD = "add";
  static const MODIFY = "modify";
  static const CREATE = "new";
  static const NO_TODOS = "noToDos";
  static const CATEGORY = "category";
  static const REMOVE_CATEGORY = "removeCategory";
  static const REMOVE_CATEGORY_BODY = "removeCategoryBody";
  static const CATEGORY_NONE = "categoryNone";
  static const ADD_TASK = "addTask";
  static const MODIFY_TASK = "modifyTask";
  static const CHOOSE_PHOTO = "choosePhoto";
  static const SETTINGS_GENERAL = "settingsGeneral";
  static const SETTINGS_USE_LOCK_SCREEN = "settingsLockScreen";
  static const SETTINGS_RESET_PASSWORD = "settingsResetPassword";
  static const SETTINGS_RECOVERY_EMAIL = "settingsRecoveryEmail";
  static const INVALID_RECOVERY_EMAIL = "invalidRecoveryEmail";
  static const SEND_TEMP_PASSWORD = "sendTempPassword";
  static const CONFIRM_SEND_TEMP_PASSWORD = "confirmSendTempPassword";
  static const CONFIRM_SEND_TEMP_PASSWORD_BODY = "confirmSendTempPasswordBody";
  static const FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR = "failedToSaveTempPasswordByUnknownError";
  static const TEMP_PASSWORD_MAIL_SUBJECT = "tempPasswordMailSubject";
  static const TEMP_PASSWORD_MAIL_BODY = "tempPasswordMailBody";
  static const TEMP_PASSWORD_MAIL_SENT = "tempPasswordMailSent";
  static const TEMP_PASSWORD_MAIL_SEND_FAILED = "tempPasswordMailSendFailed";
  static const REMOVE_SELECTED_TO_DOS_TITLE = "removeSelectedToDosTitle";
  static const RECORD_NAVIGATION_TITLE = "recordNavigationTitle";
  static const SETTINGS_NAVIGATION_TITLE = "settingsNavigationTitle";
  static const CHECK_POINT_HINT = "checkPointHint";
  static const DAY_MEMO_HINT = "dayMemoHint";
  static const FIRST_TO_DO_CHECK_TITLE = "firstToDoCheckTitle";
  static const FIRST_TO_DO_CHECK_BODY = "firstToDoCheckBody";
  static const WEEK_TUTORIAL_HI = "weekTutorialHi";
  static const WEEK_TUTORIAL_EXPLAIN = "weekTutorialExplain";
  static const WEEK_TUTORIAL_CLICK_OR_SWIPE = "weekTutorialClickOrSwipe";
  static const PREV = "prev";
  static const NEXT = "next";
  static const START = "start";
  static const DONE = "done";
  static const WEEK_TUTORIAL_CHECK_POINTS = "weekTutorialCheckPoints";
  static const WEEK_TUTORIAL_DAY_PREVIEW = "weekTutorialDayPreview";

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      NEW_PASSWORD: 'New Password',
      CONFIRM_NEW_PASSWORD: 'Confirm New Password',
      CONFIRM_PASSWORD_FAIL: 'Incorrect',
      CURRENT_PASSWORD: 'Current Password',
      RETRY_INPUT_PASSWORD: 'Retry Password',
      CREATE_PASSWORD: 'Create Password',
      CREATE_PASSWORD_BODY: 'You haven\'t set your password yet!\nGo create new password?',
      CREATE_PASSWORD_SUCCESS: 'Password has been set successfully!',
      CREATE_PASSWORD_FAIL: 'Password has not been set',
      UNLOCK_FAIL: 'Failed to unlock',
      PASSWORD_CHANGED: 'Password changed!',
      PASSWORD_UNCHANGED: 'Password not changed',
      CANCEL: 'Cancel',
      OK: 'Ok',
      ADD: 'Add',
      MODIFY: 'Modify',
      CREATE: 'Create',
      NO_TODOS: 'No TODO yet!',
      CATEGORY: 'Category',
      REMOVE_CATEGORY: 'Remove Category',
      REMOVE_CATEGORY_BODY: 'Are you sure you want to remove this category?',
      CATEGORY_NONE: 'None',
      ADD_TASK: 'Add Task',
      MODIFY_TASK: 'Modify Task',
      CHOOSE_PHOTO: 'Choose Photo',
      SETTINGS_GENERAL: 'General',
      SETTINGS_USE_LOCK_SCREEN: 'LockScreen',
      SETTINGS_RESET_PASSWORD: 'Reset Password',
      SETTINGS_RECOVERY_EMAIL: 'Recovery Email',
      INVALID_RECOVERY_EMAIL: 'Recovery email is either empty or invalid',
      SEND_TEMP_PASSWORD: 'Send Temporary Password',
      CONFIRM_SEND_TEMP_PASSWORD: 'Send Temporary Password',
      CONFIRM_SEND_TEMP_PASSWORD_BODY: 'Your previous password will be overriden by temporary password, and will be sent to your recovery email.',
      FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR: 'Failed to save temporary password by unknown error',
      TEMP_PASSWORD_MAIL_SUBJECT: '[Blue Diary] Your temporary password has been set',
      TEMP_PASSWORD_MAIL_BODY: 'Your password has been set: ',
      TEMP_PASSWORD_MAIL_SENT: 'Mail has been sent! Check your recovery email.',
      TEMP_PASSWORD_MAIL_SEND_FAILED: 'Mail has not been sent. Please check your recovery email again.',
      REMOVE_SELECTED_TO_DOS_TITLE: 'Remove TODO',
      RECORD_NAVIGATION_TITLE: 'Record',
      SETTINGS_NAVIGATION_TITLE: 'Settings',
      CHECK_POINT_HINT: 'Anything to remind yourself?',
      DAY_MEMO_HINT: 'Memo for today. Anything.',
      FIRST_TO_DO_CHECK_TITLE: 'Irreversible action',
      FIRST_TO_DO_CHECK_BODY: 'We treat completing task a very valuable action. Therefore, it\'s impossible to undo completing task unless deleting it.\n(This message is shown only once.)',
      WEEK_TUTORIAL_HI: 'Welcome!',
      WEEK_TUTORIAL_EXPLAIN: 'Ready to start?',
      WEEK_TUTORIAL_CLICK_OR_SWIPE: 'Swipe the screen\nto change week.',
      PREV: 'Prev',
      NEXT: 'Next',
      START: 'Start',
      DONE: 'Done',
      WEEK_TUTORIAL_CHECK_POINTS: 'Write and focus on your\nthree most important points.',
      WEEK_TUTORIAL_DAY_PREVIEW: 'Click and start writing for today!\nWish you a great day :)'
    },
    'ko': {
      NEW_PASSWORD: '새 비밀번호 생성',
      CONFIRM_NEW_PASSWORD: '새 비밀번호 확인',
      CONFIRM_PASSWORD_FAIL: '일치하지 않습니다.',
      CURRENT_PASSWORD: '현재 비밀번호 입력',
      RETRY_INPUT_PASSWORD: '다시 입력해 주세요.',
      CREATE_PASSWORD: '비밀번호 설정',
      CREATE_PASSWORD_BODY: '아직 설정된 비밀번호가 없네요!\n비밀번호를 새로 만드시겠어요?',
      CREATE_PASSWORD_SUCCESS: '비밀번호가 설정되었습니다!',
      CREATE_PASSWORD_FAIL: '비밀번호가 설정되지 않았습니다',
      UNLOCK_FAIL: '잠금해제에 실패하였습니다',
      PASSWORD_CHANGED: '비밀번호가 변경되었습니다!',
      PASSWORD_UNCHANGED: '비밀번호가 변경되지 않았습니다.',
      CANCEL: '취소',
      OK: '확인',
      ADD: '추가',
      MODIFY: '수정',
      CREATE: '생성',
      NO_TODOS: '기록이 없습니다',
      CATEGORY: '카테고리',
      REMOVE_CATEGORY: '카테고리 삭제',
      REMOVE_CATEGORY_BODY: '이 카테고리를 삭제하시겠습니까?',
      CATEGORY_NONE: '없음',
      ADD_TASK: '작업 추가',
      MODIFY_TASK: '작업 수정',
      CHOOSE_PHOTO: '사진 선택',
      SETTINGS_GENERAL: '일반',
      SETTINGS_USE_LOCK_SCREEN: '잠금화면',
      SETTINGS_RESET_PASSWORD: '비밀번호 재설정',
      SETTINGS_RECOVERY_EMAIL: '복원 이메일',
      INVALID_RECOVERY_EMAIL: '복원 이메일이 비어있거나 이메일 형식이 아닙니다',
      SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD_BODY: '기존의 비밀번호가 임시 비밀번호로 바뀌고, 임시 비밀번호가 복원 이메일로 전송됩니다.',
      FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR: '알 수 없는 오류로 임시 비밀번호 설정에 실패하였습니다',
      TEMP_PASSWORD_MAIL_SUBJECT: '[Blue Diary] 임시 비밀번호',
      TEMP_PASSWORD_MAIL_BODY: '비밀번호가 다음과 같이 설정되었습니다: ',
      TEMP_PASSWORD_MAIL_SENT: '메일이 발송되었습니다! 이메일을 확인해주세요.',
      TEMP_PASSWORD_MAIL_SEND_FAILED: '메일 발송에 실패하였습니다. 복원 이메일을 확인해주세요.',
      REMOVE_SELECTED_TO_DOS_TITLE: '작업 삭제',
      RECORD_NAVIGATION_TITLE: '기록',
      SETTINGS_NAVIGATION_TITLE: '설정',
      CHECK_POINT_HINT: '이번주의 다짐을 적어보세요.',
      DAY_MEMO_HINT: '오늘의 메모를 적어보세요.',
      FIRST_TO_DO_CHECK_TITLE: '취소 불가능한 행위',
      FIRST_TO_DO_CHECK_BODY: '저희는 작업을 완료하는 행위에 큰 의미를 두고자 합니다. 따라서 한 번 완료한 작업은 지우지 않는 한 취소할 수 없습니다.\n(이 메세지는 최초 한 번만 노출됩니다.)',
      WEEK_TUTORIAL_HI: '반갑습니다!',
      WEEK_TUTORIAL_EXPLAIN: '시작해볼까요?',
      WEEK_TUTORIAL_CLICK_OR_SWIPE: '화면을 스와이프하여\n이전, 다음 주로 이동하세요.',
      PREV: '이전',
      NEXT: '다음',
      START: '시작',
      DONE: '완료',
      WEEK_TUTORIAL_CHECK_POINTS: '이번 주의 가장 중요한\n세 가지 포인트를 적어보세요.',
      WEEK_TUTORIAL_DAY_PREVIEW: '오늘부터 시작해보세요!\n좋은 하루가 되길 바랍니다 :)'
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get newPassword => _localizedValues[locale.languageCode][NEW_PASSWORD];
  String get confirmNewPassword => _localizedValues[locale.languageCode][CONFIRM_NEW_PASSWORD];
  String get confirmPasswordFail => _localizedValues[locale.languageCode][CONFIRM_PASSWORD_FAIL];
  String get currentPassword => _localizedValues[locale.languageCode][CURRENT_PASSWORD];
  String get retryInputPassword => _localizedValues[locale.languageCode][RETRY_INPUT_PASSWORD];
  String get createPassword => _localizedValues[locale.languageCode][CREATE_PASSWORD];
  String get createPasswordBody => _localizedValues[locale.languageCode][CREATE_PASSWORD_BODY];
  String get createPasswordSuccess => _localizedValues[locale.languageCode][CREATE_PASSWORD_SUCCESS];
  String get createPasswordFail => _localizedValues[locale.languageCode][CREATE_PASSWORD_FAIL];
  String get unlockFail => _localizedValues[locale.languageCode][UNLOCK_FAIL];
  String get passwordChanged => _localizedValues[locale.languageCode][PASSWORD_CHANGED];
  String get passwordUnchanged => _localizedValues[locale.languageCode][PASSWORD_UNCHANGED];
  String get cancel => _localizedValues[locale.languageCode][CANCEL];
  String get ok => _localizedValues[locale.languageCode][OK];
  String get add => _localizedValues[locale.languageCode][ADD];
  String get modify => _localizedValues[locale.languageCode][MODIFY];
  String get create => _localizedValues[locale.languageCode][CREATE];
  String get noToDos => _localizedValues[locale.languageCode][NO_TODOS];
  String get category => _localizedValues[locale.languageCode][CATEGORY];
  String get removeCategory => _localizedValues[locale.languageCode][REMOVE_CATEGORY];
  String get removeCategoryBody => _localizedValues[locale.languageCode][REMOVE_CATEGORY_BODY];
  String get categoryNone => _localizedValues[locale.languageCode][CATEGORY_NONE];
  String get addTask => _localizedValues[locale.languageCode][ADD_TASK];
  String get modifyTask => _localizedValues[locale.languageCode][MODIFY_TASK];
  String get choosePhoto => _localizedValues[locale.languageCode][CHOOSE_PHOTO];
  String get settingsGeneral => _localizedValues[locale.languageCode][SETTINGS_GENERAL];
  String get settingsUseLockScreen => _localizedValues[locale.languageCode][SETTINGS_USE_LOCK_SCREEN];
  String get settingsResetPassword => _localizedValues[locale.languageCode][SETTINGS_RESET_PASSWORD];
  String get settingsRecoveryEmail => _localizedValues[locale.languageCode][SETTINGS_RECOVERY_EMAIL];
  String get invalidRecoveryEmail => _localizedValues[locale.languageCode][INVALID_RECOVERY_EMAIL];
  String get sendTempPassword => _localizedValues[locale.languageCode][SEND_TEMP_PASSWORD];
  String get confirmSendTempPassword => _localizedValues[locale.languageCode][CONFIRM_SEND_TEMP_PASSWORD];
  String get confirmSendTempPasswordBody => _localizedValues[locale.languageCode][CONFIRM_SEND_TEMP_PASSWORD_BODY];
  String get failedToSaveTempPasswordByUnknownError => _localizedValues[locale.languageCode][FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR];
  String get tempPasswordMailSubject => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_SUBJECT];
  String get tempPasswordMailBody => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_BODY];
  String get tempPasswordMailSent => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_SENT];
  String get tempPasswordMailSendFailed => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_SEND_FAILED];
  String get removeSelectedToDosTitle => _localizedValues[locale.languageCode][REMOVE_SELECTED_TO_DOS_TITLE];
  String get recordNavigationTitle => _localizedValues[locale.languageCode][RECORD_NAVIGATION_TITLE];
  String get settingsNavigationTitle => _localizedValues[locale.languageCode][SETTINGS_NAVIGATION_TITLE];
  String get checkPointHint => _localizedValues[locale.languageCode][CHECK_POINT_HINT];
  String get dayMemoHint => _localizedValues[locale.languageCode][DAY_MEMO_HINT];
  String get firstToDoCheckTitle => _localizedValues[locale.languageCode][FIRST_TO_DO_CHECK_TITLE];
  String get firstToDoCheckBody => _localizedValues[locale.languageCode][FIRST_TO_DO_CHECK_BODY];
  String get weekTutorialHi => _localizedValues[locale.languageCode][WEEK_TUTORIAL_HI];
  String get weekTutorialExplain => _localizedValues[locale.languageCode][WEEK_TUTORIAL_EXPLAIN];
  String get weekTutorialClickOrSwipe => _localizedValues[locale.languageCode][WEEK_TUTORIAL_CLICK_OR_SWIPE];
  String get prev => _localizedValues[locale.languageCode][PREV];
  String get next => _localizedValues[locale.languageCode][NEXT];
  String get start => _localizedValues[locale.languageCode][START];
  String get done => _localizedValues[locale.languageCode][DONE];
  String get weekTutorialCheckPoints => _localizedValues[locale.languageCode][WEEK_TUTORIAL_CHECK_POINTS];
  String get weekTutorialDayPreview => _localizedValues[locale.languageCode][WEEK_TUTORIAL_DAY_PREVIEW];

  String getMonthAndNthWeek(int month, int nthWeek) {
    if (locale.languageCode == 'ko') {
      switch (nthWeek) {
        case 0:
          return '$month월 첫째주';
        case 1:
          return '$month월 둘째주';
        case 2:
          return '$month월 셋째주';
        case 3:
          return '$month월 넷째주';
        case 4:
        default:
          return '$month월 다섯째주';
      }
    } else {
      final monthName = _getMonthNameShort(month);
      switch (nthWeek) {
        case 0:
          return '1st Week of $monthName';
        case 1:
          return '2nd Week of $monthName';
        case 2:
          return '3rd Week of $monthName';
        case 3:
          return '4th Week of $monthName';
        case 4:
        default:
          return '5th Week of $monthName';
      }
    }
  }

  String _getMonthNameShort(int month) {
    return month == DateTime.january ? 'Jan'
      : month == DateTime.february ? 'Feb'
      : month == DateTime.march ? 'Mar'
      : month == DateTime.april ? 'Apr'
      : month == DateTime.may ? 'May'
      : month == DateTime.june ? 'Jun'
      : month == DateTime.july ? 'Jul'
      : month == DateTime.august ? 'Aug'
      : month == DateTime.september ? 'Sep'
      : month == DateTime.october ? 'Oct'
      : month == DateTime.november ? 'Nov'
      : 'Dec';
  }

  String _getMonthName(int month) {
    return month == DateTime.january ? 'January'
      : month == DateTime.february ? 'February'
      : month == DateTime.march ? 'March'
      : month == DateTime.april ? 'April'
      : month == DateTime.may ? 'May'
      : month == DateTime.june ? 'June'
      : month == DateTime.july ? 'July'
      : month == DateTime.august ? 'August'
      : month == DateTime.september ? 'Sepember'
      : month == DateTime.october ? 'October'
      : month == DateTime.november ? 'November'
      : 'December';
  }

  String getDayPreviewTitle(int month, int day, int weekday) {
    final weekdayString = _getWeekDayName(weekday);
    if (locale.languageCode == 'ko') {
      return '$month월 $day일 $weekdayString';
    } else {
      return '$weekdayString, ${_getMonthName(month)} $day';
    }
  }

  String getDayScreenTitle(int month, int day, int weekday) {
    final weekdayString = _getWeekDayName(weekday);
    if (locale.languageCode == 'ko') {
      return '$month월 $day일 $weekdayString';
    } else {
      return '$weekdayString, ${_getMonthName(month)} $day';
    }
  }

  String _getWeekDayName(int weekDay) {
    if (locale.languageCode == 'ko') {
      if (weekDay == DateTime.monday) {
        return '월요일';
      } else if (weekDay == DateTime.tuesday) {
        return '화요일';
      } else if (weekDay == DateTime.wednesday) {
        return '수요일';
      } else if (weekDay == DateTime.thursday) {
        return '목요일';
      } else if (weekDay == DateTime.friday) {
        return '금요일';
      } else if (weekDay == DateTime.saturday) {
        return '토요일';
      } else {
        return '일요일';
      }
    } else {
      if (weekDay == DateTime.monday) {
        return 'Mon';
      } else if (weekDay == DateTime.tuesday) {
        return 'Tue';
      } else if (weekDay == DateTime.wednesday) {
        return 'Wed';
      } else if (weekDay == DateTime.thursday) {
        return 'Thu';
      } else if (weekDay == DateTime.friday) {
        return 'Fri';
      } else if (weekDay == DateTime.saturday) {
        return 'Sat';
      } else {
        return 'Sun';
      }
    }
  }

  String getMoreToDos(int count) {
    if (locale.languageCode == 'ko') {
      return ' 외 $count개';
    } else {
      return ' and $count more';
    }
  }

  String getRemoveSelectedToDosBody(int count) {
    if (locale.languageCode == 'ko') {
      return '$count개의 작업을 삭제하시겠습니까?';
    } else {
      return 'Are you sure you want to remove $count tasks?';
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }
}