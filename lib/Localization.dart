
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';

class AppLocalizations {
  static const NEW_PASSWORD = "newPassword";
  static const CONFIRM_NEW_PASSWORD = "confirmNewPassword";
  static const CONFIRM_PASSWORD_FAIL = "confirmPasswordFail";
  static const INPUT_PASSWORD = "inputPassword";
  static const RETRY_INPUT_PASSWORD = "retryInputPassword";
  static const CREATE_PASSWORD = "createPassword";
  static const CREATE_PASSWORD_BODY = "createPasswordBody";
  static const CREATE_PASSWORD_SUCCESS = "createPasswordSuccess";
  static const CREATE_PASSWORD_FAIL = "createPasswordFail";
  static const UNLOCK_FAIL = "unlockFail";

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

  static const DRAWER_RECORD = "drawerRecord";
  static const DRAWER_SETTINGS = "drawerSettings";
  static const DRAWER_ABOUT = "drawerAbout";

  static const SETTINGS = "settings";
  static const SETTINGS_GENERAL = "settingsGeneral";
  static const SETTINGS_DEFAULT_LOCK = "settingsDefaultLock";
  static const SETTINGS_RESET_PASSWORD = "settingsResetPassword";
  static const SETTINGS_RECOVERY_EMAIL = "settingsRecoveryEmail";
  static const NO_RECOVERY_EMAIL = "noRecoveryEmail";

  static const INVALID_EMAIL = "invalidEmail";

  static const SEND_TEMP_PASSWORD = "sendTempPassword";
  static const CONFIRM_SEND_TEMP_PASSWORD = "confirmSendTempPassword";
  static const CONFIRM_SEND_TEMP_PASSWORD_BODY = "confirmSendTempPasswordBody";
  static const FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR = "failedToSaveTempPasswordByUnknownError";
  static const TEMP_PASSWORD_MAIL_SUBJECT = "tempPasswordMailSubject";
  static const TEMP_PASSWORD_MAIL_BODY = "tempPasswordMailBody";
  static const TEMP_PASSWORD_MAIL_SENT = "tempPasswordMailSent";

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      NEW_PASSWORD: 'New Password',
      CONFIRM_NEW_PASSWORD: 'Confirm New Password',
      CONFIRM_PASSWORD_FAIL: 'Incorrect',
      INPUT_PASSWORD: 'Password',
      RETRY_INPUT_PASSWORD: 'Retry Password',
      CREATE_PASSWORD: 'Create Password',
      CREATE_PASSWORD_BODY: 'You haven\'t set your password yet!\nGo create new password?',
      CREATE_PASSWORD_SUCCESS: 'Password has been set successfully!',
      CREATE_PASSWORD_FAIL: 'Password has not been set',
      UNLOCK_FAIL: 'Failed to unlock',

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

      DRAWER_RECORD: 'Record',
      DRAWER_SETTINGS: 'Settings',
      DRAWER_ABOUT: 'About',

      SETTINGS: 'Settings',
      SETTINGS_GENERAL: 'General',
      SETTINGS_DEFAULT_LOCK: 'Lock By Default',
      SETTINGS_RESET_PASSWORD: 'Reset Password',
      SETTINGS_RECOVERY_EMAIL: 'Recovery Email',
      NO_RECOVERY_EMAIL: 'Please write your recovery email first',

      INVALID_EMAIL: 'Invalid Email',

      SEND_TEMP_PASSWORD: 'Send Temporary Password',
      CONFIRM_SEND_TEMP_PASSWORD: 'Send Temporary Password',
      CONFIRM_SEND_TEMP_PASSWORD_BODY: 'Your previous password will be overriden by temporary password, and will be sent to your recovery email.',
      FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR: 'Failed to save temporary password by unknown error',
      TEMP_PASSWORD_MAIL_SUBJECT: '[Blue Diary] Your temporary password has been set',
      TEMP_PASSWORD_MAIL_BODY: 'Your password has been set as below:\n',
      TEMP_PASSWORD_MAIL_SENT: 'Password has been reset. Please check your recovery email.',
    },
    'ko': {
      NEW_PASSWORD: '새 비밀번호 생성',
      CONFIRM_NEW_PASSWORD: '새 비밀번호 확인',
      CONFIRM_PASSWORD_FAIL: '일치하지 않습니다.',
      INPUT_PASSWORD: '비밀번호 입력',
      RETRY_INPUT_PASSWORD: '다시 입력해 주세요.',
      CREATE_PASSWORD: '비밀번호 설정',
      CREATE_PASSWORD_BODY: '아직 설정된 비밀번호가 없네요!\n비밀번호를 새로 만드시겠어요?',
      CREATE_PASSWORD_SUCCESS: '비밀번호가 설정되었습니다!',
      CREATE_PASSWORD_FAIL: '비밀번호가 설정되지 않았습니다',
      UNLOCK_FAIL: '잠금해제에 실패하였습니다',

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

      DRAWER_RECORD: '기록',
      DRAWER_SETTINGS: '설정',
      DRAWER_ABOUT: 'About',

      SETTINGS: '설정',
      SETTINGS_GENERAL: '일반',
      SETTINGS_DEFAULT_LOCK: '디폴트로 잠금',
      SETTINGS_RESET_PASSWORD: '비밀번호 재설정',
      SETTINGS_RECOVERY_EMAIL: '복원 이메일',
      NO_RECOVERY_EMAIL: '복원 이메일을 먼저 작성해주세요',

      INVALID_EMAIL: '올바른 이메일 형식이 아닙니다',

      SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD_BODY: '기존의 비밀번호가 임시 비밀번호로 바뀌고, 임시 비밀번호가 복원 이메일로 전송됩니다.',
      FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR: '알 수 없는 오류로 임시 비밀번호 설정에 실패하였습니다',
      TEMP_PASSWORD_MAIL_SUBJECT: '[Blue Diary] 임시 비밀번호',
      TEMP_PASSWORD_MAIL_BODY: '비밀번호가 아래와 같이 설정되었습니다:\n',
      TEMP_PASSWORD_MAIL_SENT: '비밀번호가 재설정되었습니다. 복원 이메일을 확인해주세요.',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get newPassword => _localizedValues[locale.languageCode][NEW_PASSWORD];
  String get confirmNewPassword => _localizedValues[locale.languageCode][CONFIRM_NEW_PASSWORD];
  String get confirmPasswordFail => _localizedValues[locale.languageCode][CONFIRM_PASSWORD_FAIL];
  String get inputPassword => _localizedValues[locale.languageCode][INPUT_PASSWORD];
  String get retryInputPassword => _localizedValues[locale.languageCode][RETRY_INPUT_PASSWORD];
  String get createPassword => _localizedValues[locale.languageCode][CREATE_PASSWORD];
  String get createPasswordBody => _localizedValues[locale.languageCode][CREATE_PASSWORD_BODY];
  String get createPasswordSuccess => _localizedValues[locale.languageCode][CREATE_PASSWORD_SUCCESS];
  String get createPasswordFail => _localizedValues[locale.languageCode][CREATE_PASSWORD_FAIL];
  String get unlockFail => _localizedValues[locale.languageCode][UNLOCK_FAIL];

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

  String get settings => _localizedValues[locale.languageCode][SETTINGS];
  String get settingsGeneral => _localizedValues[locale.languageCode][SETTINGS_GENERAL];
  String get settingsDefaultLock => _localizedValues[locale.languageCode][SETTINGS_DEFAULT_LOCK];
  String get settingsResetPassword => _localizedValues[locale.languageCode][SETTINGS_RESET_PASSWORD];
  String get settingsRecoveryEmail => _localizedValues[locale.languageCode][SETTINGS_RECOVERY_EMAIL];
  String get noRecoveryEmail => _localizedValues[locale.languageCode][NO_RECOVERY_EMAIL];

  String get invalidEmail => _localizedValues[locale.languageCode][INVALID_EMAIL];

  String get sendTempPassword => _localizedValues[locale.languageCode][SEND_TEMP_PASSWORD];
  String get confirmSendTempPassword => _localizedValues[locale.languageCode][CONFIRM_SEND_TEMP_PASSWORD];
  String get confirmSendTempPasswordBody => _localizedValues[locale.languageCode][CONFIRM_SEND_TEMP_PASSWORD_BODY];
  String get failedToSaveTempPasswordByUnknownError => _localizedValues[locale.languageCode][FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR];
  String get tempPasswordMailSubject => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_SUBJECT];
  String get tempPasswordMailBody => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_BODY];
  String get tempPasswordMailSent => _localizedValues[locale.languageCode][TEMP_PASSWORD_MAIL_SENT];

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
      final monthName = _getMonthName(month);
      switch (nthWeek) {
        case 0:
          return '$monthName, 1st Week';
        case 1:
          return '$monthName, 2nd Week';
        case 2:
          return '$monthName, 3rd Week';
        case 3:
          return '$monthName, 4th Week';
        case 4:
        default:
          return '$monthName, 5th Week';
      }
    }
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
      : month == DateTime.september ? 'September'
      : month == DateTime.october ? 'October'
      : month == DateTime.november ? 'November'
      : 'December';
  }

  String getDayRecordTitle(int month, int day) {
    if (locale.languageCode == 'ko') {
      return '$month월 $day일';
    } else {
      return '${_getMonthName(month)} $day';
    }
  }

  String getDayScreenTitle(int month, int day, int weekday) {
    if (locale.languageCode == 'ko') {
      return '$month월 $day일 ${_getWeekDayName(weekday)}';
    } else {
      return '${_getWeekDayName(weekday)}, ${_getMonthName(month)} $day';
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
        return 'Monday';
      } else if (weekDay == DateTime.tuesday) {
        return 'Tuesday';
      } else if (weekDay == DateTime.wednesday) {
        return 'Wednesday';
      } else if (weekDay == DateTime.thursday) {
        return 'Thursday';
      } else if (weekDay == DateTime.friday) {
        return 'Friday';
      } else if (weekDay == DateTime.saturday) {
        return 'Saturday';
      } else {
        return 'Sunday';
      }
    }
  }

  String getDrawerTitle(String drawerKey) {
    switch (drawerKey) {
      case DrawerChildScreenItem.KEY_RECORD:
        return _localizedValues[locale.languageCode][DRAWER_RECORD];
      case DrawerScreenItem.KEY_SETTINGS:
        return _localizedValues[locale.languageCode][DRAWER_SETTINGS];
      case DrawerScreenItem.KEY_ABOUT:
        return _localizedValues[locale.languageCode][DRAWER_ABOUT];
      default:
        return '';
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