
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/domain/entity/Pet.dart';

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
  static const SETTINGS_LOCK = "settingsLock";
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
  static const PET_NAVIGATION_TITLE = "petNavigationTitle";
  static const RANKING_NAVIGATION_TITLE = "rankingNavigationTitle";
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
  static const DAY_TUTORIAL_SWIPE = "dayTutorialSwipe";
  static const DAY_TUTORIAL_MEMO = "dayTutorialMemo";
  static const DAY_TUTORIAL_ADD_TO_DO = "dayTutorialAddToDo";
  static const SETTINGS_ETC = "settingsEtc";
  static const SETTINGS_FEEDBACK = "settingsFeedback";
  static const LEAVE_FEEDBACK_TITLE = "leaveFeedbackTitle";
  static const LEAVE_FEEDBACK_BODY = "leaveFeedbackBody";
  static const RETRY = "retry";
  static const WEEK_SCREEN_NETWORK_ERROR_REASON = "weekScreenNetworkErrorReason";
  static const SETTINGS_DEVELOPER = "settingsDeveloper";
  static const SETTINGS_USE_REAL_FIRST_LAUNCH_DATE = "settingsUseRealFirstLaunchDate";
  static const SETTINGS_CUSTOM_FIRST_LAUNCH_DATE = "settingsCustomFirstLaunchDate";
  static const WARNING = "warning";
  static const FIRST_COMPLETABLE_DAY_TUTORIAL = "firstCompletableDayTutorial";
  static const FIRST_COMPLETABLE_DAY_TUTORIAL_SUB = "firstCompletableDayTutorialSub";
  static const CANNOT_MODIFY_COMPLETED_DAYS_TASKS = "cannotModifyCompletedDaysTasks";
  static const RANKING = "ranking";
  static const CLICK_TO_SIGN_IN_AND_JOIN = "clickToSignInAndJoin";
  static const COMPLETED_DAYS = "completedDays";
  static const CURRENT_STREAK = "currentStreak";
  static const LONGEST_STREAK = "longestStreak";
  static const THUMBS_UP = "thumbsUp";
  static const NO_PET_SELECTED = "noPetSelected";
  static const UNKNOWN_PET_NAME = "unknownPetName";
  static const UNKNOWN_PET_EGG = "unknownPetEgg";
  static const PET_A_INACTIVE_SUBTITLE = "petAInactiveSubtitle";
  static const PET_A_EGG_SUBTITLE = "petAEggSubtitle";
  static const PET_A_0_TITLE = "petA0Title";
  static const PET_A_0_SUBTITLE = "petA0Subtitle";
  static const PET_A_1_TITLE = "petA1Title";
  static const PET_A_1_SUBTITLE = "petA1Subtitle";
  static const PET_A_2_TITLE = "petA2Title";
  static const PET_A_2_SUBTITLE = "petA2Subtitle";
  static const PET_B_INACTIVE_SUBTITLE = "petBInactiveSubtitle";
  static const PET_B_EGG_SUBTITLE = "petBEggSubtitle";
  static const PET_B_0_TITLE = "petB0Title";
  static const PET_B_0_SUBTITLE = "petB0Subtitle";
  static const PET_B_1_TITLE = "petB1Title";
  static const PET_B_1_SUBTITLE = "petB1Subtitle";
  static const PET_B_2_TITLE = "petB2Title";
  static const PET_B_2_SUBTITLE = "petB2Subtitle";
  static const SIGN_OUT = "signOut";
  static const NO_PET = "noPet";
  static const NEED_UPDATE = "needUpdate";
  static const TRY_UPDATE_LATER = "tryUpdateLater";
  static const CHECK_INTERNET = "checkNetwork";
  static const SIGN_OUT_TITLE = "signOutTitle";
  static const SIGN_OUT_BODY = "signOutBody";
  static const REMINDER_NOTIFICATION_CHANNEL_NAME = "reminderNotificationChannelName";
  static const REMINDER_NOTIFICATION_CHANNEL_DESCRIPTION = "reminderNotificationChannelDescription";
  static const REMINDER_NOTIFICATION_TITLE = "reminderNotificationTitle";
  static const REMINDER_NOTIFICATION_BODY = "reminderNotificationBody";
  static const FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_NAME = "firebaseMessagingNotificationChannelName";
  static const FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_DESCRIPTION = "firebaseMessagingNotificationChannelDescription";
  static const ERROR_SIGNING_IN = "errorSigningIn";
  static const ERROR_SIGNING_OUT = "errorSigningOut";
  static const NO_RANKING_USER_INFOS = "noRankingUserInfos";
  static const RELOAD = "reload";

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
      SETTINGS_LOCK: 'Lock',
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
      PET_NAVIGATION_TITLE: 'Pet',
      RANKING_NAVIGATION_TITLE: 'Ranking',
      SETTINGS_NAVIGATION_TITLE: 'Settings',
      CHECK_POINT_HINT: 'Anything to remind yourself?',
      DAY_MEMO_HINT: 'Memo for today. Anything.',
      FIRST_TO_DO_CHECK_TITLE: 'Irreversible action',
      FIRST_TO_DO_CHECK_BODY: 'Completing a task cannot be reversed. Proceed?\n(Only shown for the first time.)',
      WEEK_TUTORIAL_HI: 'Welcome!',
      WEEK_TUTORIAL_EXPLAIN: 'Ready to start?',
      WEEK_TUTORIAL_CLICK_OR_SWIPE: 'Swipe the screen\nto change week',
      PREV: 'Prev',
      NEXT: 'Next',
      START: 'Start',
      DONE: 'Done',
      WEEK_TUTORIAL_CHECK_POINTS: 'Write and focus on your\nthree most important points',
      WEEK_TUTORIAL_DAY_PREVIEW: 'Click and start writing for today!\nYour days will get better :)',
      DAY_TUTORIAL_SWIPE: 'Swipe the screen\nto change date',
      DAY_TUTORIAL_MEMO: 'Write daily memo\nto keep up with your goals',
      DAY_TUTORIAL_ADD_TO_DO: 'Try adding your first task!\nWe\'ll help you stick to it.',
      SETTINGS_ETC: 'Etc',
      SETTINGS_FEEDBACK: 'Leave Feedback',
      LEAVE_FEEDBACK_TITLE: 'Feedback',
      LEAVE_FEEDBACK_BODY: 'Any feedback is highly welcomed!\nOpen app store to write review?',
      RETRY: 'Retry',
      WEEK_SCREEN_NETWORK_ERROR_REASON: 'Unable to get today\'s date.\nPlease check your internet.',
      SETTINGS_DEVELOPER: 'Developer',
      SETTINGS_USE_REAL_FIRST_LAUNCH_DATE: 'Use real first launch date',
      SETTINGS_CUSTOM_FIRST_LAUNCH_DATE: 'Set custom first launch date',
      WARNING: 'Warning',
      FIRST_COMPLETABLE_DAY_TUTORIAL: 'Click to complete your day and earn points!\nThe longer the streak, the more points you\'ll get.',
      FIRST_COMPLETABLE_DAY_TUTORIAL_SUB: 'Warning: You won\'t be able to modify tasks anymore',
      CANNOT_MODIFY_COMPLETED_DAYS_TASKS: 'Cannot modify completed day\'s tasks',
      RANKING: 'Ranking',
      CLICK_TO_SIGN_IN_AND_JOIN: 'Click to sign in and join',
      COMPLETED_DAYS: 'Completed days',
      CURRENT_STREAK: 'Current streak',
      LONGEST_STREAK: 'Longest streak',
      THUMBS_UP: 'Thumbs up',
      NO_PET_SELECTED: 'No pet selected',
      UNKNOWN_PET_NAME: '???',
      UNKNOWN_PET_EGG: '???\'s egg',
      PET_A_INACTIVE_SUBTITLE: 'First kid on the road!',
      PET_A_EGG_SUBTITLE: 'Ay, something\'s cooking...',
      PET_A_0_TITLE: 'A',
      PET_A_0_SUBTITLE: 'Hai!',
      PET_A_1_TITLE: 'Able',
      PET_A_1_SUBTITLE: 'Hai!',
      PET_A_2_TITLE: 'Ace!',
      PET_A_2_SUBTITLE: 'Hai!',
      PET_B_INACTIVE_SUBTITLE: 'B inactive',
      PET_B_EGG_SUBTITLE: 'B egg',
      PET_B_0_TITLE: 'B0',
      PET_B_0_SUBTITLE: 'B0_',
      PET_B_1_TITLE: 'B1',
      PET_B_1_SUBTITLE: 'B1_',
      PET_B_2_TITLE: 'B2',
      PET_B_2_SUBTITLE: 'B2_',
      SIGN_OUT: 'Sign Out',
      NO_PET: 'No Pet',
      NEED_UPDATE: 'Need Update',
      TRY_UPDATE_LATER: 'Please try again after 5 minutes',
      CHECK_INTERNET: 'Please check your internet',
      SIGN_OUT_TITLE: 'Sign Out',
      SIGN_OUT_BODY: 'You data will be deleted from ranking list.\nAre you sure?',
      REMINDER_NOTIFICATION_CHANNEL_NAME: 'Reminder',
      REMINDER_NOTIFICATION_CHANNEL_DESCRIPTION: 'Notifies you of incomplete tasks',
      REMINDER_NOTIFICATION_TITLE: 'You have incomplete tasks',
      REMINDER_NOTIFICATION_BODY: 'Complete your day and rank up!',
      FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_NAME: 'Notice',
      FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_DESCRIPTION: 'Notices from developer',
      ERROR_SIGNING_IN: 'Error signing in',
      ERROR_SIGNING_OUT: 'Error signing out',
      NO_RANKING_USER_INFOS: 'No ranking data',
      RELOAD: 'Reload',
    },
    'ko': {
      NEW_PASSWORD: '새 비밀번호 생성',
      CONFIRM_NEW_PASSWORD: '새 비밀번호 확인',
      CONFIRM_PASSWORD_FAIL: '일치하지 않습니다',
      CURRENT_PASSWORD: '현재 비밀번호 입력',
      RETRY_INPUT_PASSWORD: '다시 입력해 주세요',
      CREATE_PASSWORD: '비밀번호 설정',
      CREATE_PASSWORD_BODY: '설정된 비밀번호가 없습니다.\n새로 만드시겠습니까?',
      CREATE_PASSWORD_SUCCESS: '비밀번호가 설정되었습니다',
      CREATE_PASSWORD_FAIL: '비밀번호가 설정되지 않았습니다',
      UNLOCK_FAIL: '잠금해제에 실패하였습니다',
      PASSWORD_CHANGED: '비밀번호가 변경되었습니다',
      PASSWORD_UNCHANGED: '비밀번호가 변경되지 않았습니다',
      CANCEL: '취소',
      OK: '확인',
      ADD: '추가',
      MODIFY: '수정',
      CREATE: '생성',
      NO_TODOS: '기록이 없습니다',
      CATEGORY: '카테고리',
      REMOVE_CATEGORY: '카테고리 삭제',
      REMOVE_CATEGORY_BODY: '해당 카테고리를 삭제하시겠습니까?',
      CATEGORY_NONE: '없음',
      ADD_TASK: '작업 추가',
      MODIFY_TASK: '작업 수정',
      CHOOSE_PHOTO: '사진 선택',
      SETTINGS_LOCK: '잠금',
      SETTINGS_USE_LOCK_SCREEN: '잠금화면',
      SETTINGS_RESET_PASSWORD: '비밀번호 재설정',
      SETTINGS_RECOVERY_EMAIL: '복원 이메일',
      INVALID_RECOVERY_EMAIL: '복원 이메일이 비어있거나 이메일 형식이 아닙니다',
      SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD: '임시 비밀번호 발송',
      CONFIRM_SEND_TEMP_PASSWORD_BODY: '기존의 비밀번호가 임시 비밀번호로 바뀌며, 복원 이메일로 임시 비밀번호가 전송됩니다',
      FAILED_TO_SAVE_TEMP_PASSWORD_BY_UNKNOWN_ERROR: '알 수 없는 오류로 임시 비밀번호 설정에 실패하였습니다',
      TEMP_PASSWORD_MAIL_SUBJECT: '[Blue Diary] 임시 비밀번호',
      TEMP_PASSWORD_MAIL_BODY: '비밀번호가 다음과 같이 설정되었습니다: ',
      TEMP_PASSWORD_MAIL_SENT: '메일이 발송되었습니다! 이메일을 확인해주세요.',
      TEMP_PASSWORD_MAIL_SEND_FAILED: '메일 발송에 실패하였습니다. 복원 이메일을 확인해주세요.',
      REMOVE_SELECTED_TO_DOS_TITLE: '작업 삭제',
      RECORD_NAVIGATION_TITLE: '기록',
      PET_NAVIGATION_TITLE: '펫',
      RANKING_NAVIGATION_TITLE: '랭킹',
      SETTINGS_NAVIGATION_TITLE: '설정',
      CHECK_POINT_HINT: '이번주의 다짐을 적어보세요',
      DAY_MEMO_HINT: '오늘의 메모를 적어보세요',
      FIRST_TO_DO_CHECK_TITLE: '취소 불가능한 행위',
      FIRST_TO_DO_CHECK_BODY: '완료된 작업은 다시 미완료로 변경할 수 없습니다. 진행하시겠습니까?\n(최초 한번만 보여집니다.)',
      WEEK_TUTORIAL_HI: '환영합니다!',
      WEEK_TUTORIAL_EXPLAIN: '준비되셨나요?',
      WEEK_TUTORIAL_CLICK_OR_SWIPE: '화면을 스와이프해서\n이전, 다음 주로 이동해보세요',
      PREV: '이전',
      NEXT: '다음',
      START: '시작',
      DONE: '완료',
      WEEK_TUTORIAL_CHECK_POINTS: '이번 주의 가장 중요한\n세 가지 포인트를 적어보세요',
      WEEK_TUTORIAL_DAY_PREVIEW: '오늘부터 시작해보세요!\n하루 하루가 달라질거에요 :)',
      DAY_TUTORIAL_SWIPE: '화면을 스와이프해서\n날짜를 바꿔보세요',
      DAY_TUTORIAL_MEMO: '매일 메모를 작성하며\n자신의 목표를 되새겨보세요',
      DAY_TUTORIAL_ADD_TO_DO: '첫번째 작업을 추가해보세요!\n해낼 수 있게 도와드리겠습니다.',
      SETTINGS_ETC: '기타',
      SETTINGS_FEEDBACK: '의견 남기기',
      LEAVE_FEEDBACK_TITLE: '의견 남기기',
      LEAVE_FEEDBACK_BODY: '어떤 의견이든 환영합니다! 의견을 작성하기 위해 스토어로 이동합니다.',
      RETRY: '다시 시도',
      WEEK_SCREEN_NETWORK_ERROR_REASON: '오늘 날짜를 확인할 수 없습니다.\n인터넷을 확인해주세요.',
      SETTINGS_DEVELOPER: '개발자 설정',
      SETTINGS_USE_REAL_FIRST_LAUNCH_DATE: '실제 첫 실행 날짜 사용',
      SETTINGS_CUSTOM_FIRST_LAUNCH_DATE: '커스텀 첫 실행 날짜 설정',
      WARNING: '주의',
      FIRST_COMPLETABLE_DAY_TUTORIAL: '클릭해서 하루를 완료하고 점수를 얻으세요!\n연속으로 완료시 더 많은 점수를 얻을 수 있습니다.',
      FIRST_COMPLETABLE_DAY_TUTORIAL_SUB: '주의: 완료한 날짜의 작업은 수정이 불가합니다',
      CANNOT_MODIFY_COMPLETED_DAYS_TASKS: '완료한 날짜의 작업은 수정이 불가합니다.',
      RANKING: '랭킹',
      CLICK_TO_SIGN_IN_AND_JOIN: '클릭해서 참여해보세요',
      COMPLETED_DAYS: '완료한 날들',
      CURRENT_STREAK: '현재 연속 횟수',
      LONGEST_STREAK: '최대 연속 횟수',
      THUMBS_UP: '좋아요 갯수',
      NO_PET_SELECTED: '선택된 펫이 없습니다',
      UNKNOWN_PET_NAME: '???',
      UNKNOWN_PET_EGG: '???의 알',
      PET_A_INACTIVE_SUBTITLE: '첫번째 아이가 누굴까요?',
      PET_A_EGG_SUBTITLE: '뭔가 타는 냄새 안나요?',
      PET_A_0_TITLE: '에이',
      PET_A_0_SUBTITLE: '안녕!',
      PET_A_1_TITLE: '에이블',
      PET_A_1_SUBTITLE: '안녕!',
      PET_A_2_TITLE: '에이스!',
      PET_A_2_SUBTITLE: '안녕!',
      PET_B_INACTIVE_SUBTITLE: 'B inactive',
      PET_B_EGG_SUBTITLE: 'B egg',
      PET_B_0_TITLE: 'B0',
      PET_B_0_SUBTITLE: 'B0_',
      PET_B_1_TITLE: 'B1',
      PET_B_1_SUBTITLE: 'B1_',
      PET_B_2_TITLE: 'B2',
      PET_B_2_SUBTITLE: 'B2_',
      SIGN_OUT: '탈퇴',
      NO_PET: '펫 없음',
      NEED_UPDATE: '업데이트 필요',
      TRY_UPDATE_LATER: '5분 후 다시 시도해주세요',
      CHECK_INTERNET: '인터넷 상태를 확인해주세요.',
      SIGN_OUT_TITLE: '탈퇴',
      SIGN_OUT_BODY: '당신의 데이터가 랭킹 목록으로부터 삭제됩니다.\n진행하시겠습니까?',
      REMINDER_NOTIFICATION_CHANNEL_NAME: '리마인더',
      REMINDER_NOTIFICATION_CHANNEL_DESCRIPTION: '아직 끝내지 못한 작업에 대해 알립니다',
      REMINDER_NOTIFICATION_TITLE: '남아있는 작업이 있습니다',
      REMINDER_NOTIFICATION_BODY: '오늘을 완료하고 랭킹을 올려보세요!',
      FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_NAME: '공지사항',
      FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_DESCRIPTION: '개발자로부터의 공지사항',
      ERROR_SIGNING_IN: '가입에 실패하였습니다',
      ERROR_SIGNING_OUT: '탈퇴에 실패하였습니다',
      NO_RANKING_USER_INFOS: '랭킹 데이터가 없습니다',
      RELOAD: '재시도',
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
  String get settingsLock => _localizedValues[locale.languageCode][SETTINGS_LOCK];
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
  String get dayTutorialSwipe => _localizedValues[locale.languageCode][DAY_TUTORIAL_SWIPE];
  String get dayTutorialMemo => _localizedValues[locale.languageCode][DAY_TUTORIAL_MEMO];
  String get dayTutorialAddToDo => _localizedValues[locale.languageCode][DAY_TUTORIAL_ADD_TO_DO];
  String get settingsEtc => _localizedValues[locale.languageCode][SETTINGS_ETC];
  String get settingsFeedback => _localizedValues[locale.languageCode][SETTINGS_FEEDBACK];
  String get leaveFeedbackTitle => _localizedValues[locale.languageCode][LEAVE_FEEDBACK_TITLE];
  String get leaveFeedbackBody => _localizedValues[locale.languageCode][LEAVE_FEEDBACK_BODY];
  String get retry => _localizedValues[locale.languageCode][RETRY];
  String get weekScreenNetworkErrorReason => _localizedValues[locale.languageCode][WEEK_SCREEN_NETWORK_ERROR_REASON];
  String get settingsDeveloper => _localizedValues[locale.languageCode][SETTINGS_DEVELOPER];
  String get settingsUseRealFirstLaunchDate => _localizedValues[locale.languageCode][SETTINGS_USE_REAL_FIRST_LAUNCH_DATE];
  String get settingsCustomFirstLaunchDate => _localizedValues[locale.languageCode][SETTINGS_CUSTOM_FIRST_LAUNCH_DATE];
  String get warning => _localizedValues[locale.languageCode][WARNING];
  String get firstCompletableDayTutorial => _localizedValues[locale.languageCode][FIRST_COMPLETABLE_DAY_TUTORIAL];
  String get firstCompletableDayTutorialSub => _localizedValues[locale.languageCode][FIRST_COMPLETABLE_DAY_TUTORIAL_SUB];
  String get cannotModifyCompletedDaysTasks => _localizedValues[locale.languageCode][CANNOT_MODIFY_COMPLETED_DAYS_TASKS];
  String get ranking => _localizedValues[locale.languageCode][RANKING];
  String get clickToSignInAndJoin => _localizedValues[locale.languageCode][CLICK_TO_SIGN_IN_AND_JOIN];
  String get completedDays => _localizedValues[locale.languageCode][COMPLETED_DAYS];
  String get currentStreak => _localizedValues[locale.languageCode][CURRENT_STREAK];
  String get longestStreak => _localizedValues[locale.languageCode][LONGEST_STREAK];
  String get thumbsUp => _localizedValues[locale.languageCode][THUMBS_UP];
  String get noPetSelected => _localizedValues[locale.languageCode][NO_PET_SELECTED];
  String get signOut => _localizedValues[locale.languageCode][SIGN_OUT];
  String get noPet => _localizedValues[locale.languageCode][NO_PET];
  String get needUpdate => _localizedValues[locale.languageCode][NEED_UPDATE];
  String get tryUpdateLater => _localizedValues[locale.languageCode][TRY_UPDATE_LATER];
  String get checkInternet => _localizedValues[locale.languageCode][CHECK_INTERNET];
  String get signOutTitle => _localizedValues[locale.languageCode][SIGN_OUT_TITLE];
  String get signOutBody => _localizedValues[locale.languageCode][SIGN_OUT_BODY];
  String get reminderNotificationChannelName => _localizedValues[locale.languageCode][REMINDER_NOTIFICATION_CHANNEL_NAME];
  String get reminderNotificationChannelDescription => _localizedValues[locale.languageCode][REMINDER_NOTIFICATION_CHANNEL_DESCRIPTION];
  String get reminderNotificationTitle => _localizedValues[locale.languageCode][REMINDER_NOTIFICATION_TITLE];
  String get reminderNotificationBody => _localizedValues[locale.languageCode][REMINDER_NOTIFICATION_BODY];
  String get firebaseMessagingNotificationChannelName => _localizedValues[locale.languageCode][FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_NAME];
  String get firebaseMessagingNotificationChannelDescription => _localizedValues[locale.languageCode][FIREBASE_MESSAGING_NOTIFICATION_CHANNEL_DESCRIPTION];
  String get errorSigningIn => _localizedValues[locale.languageCode][ERROR_SIGNING_IN];
  String get errorSigningOut => _localizedValues[locale.languageCode][ERROR_SIGNING_OUT];
  String get noRankingUserInfos => _localizedValues[locale.languageCode][NO_RANKING_USER_INFOS];
  String get reload => _localizedValues[locale.languageCode][RELOAD];

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

  String getBottomNavigationTitle(String key) {
    switch (key) {
      case HomeChildScreenItem.KEY_RECORD:
        return _localizedValues[locale.languageCode][RECORD_NAVIGATION_TITLE];
      case HomeChildScreenItem.KEY_PET:
        return _localizedValues[locale.languageCode][PET_NAVIGATION_TITLE];
      case HomeChildScreenItem.KEY_RANKING:
        return _localizedValues[locale.languageCode][RANKING_NAVIGATION_TITLE];
      case HomeChildScreenItem.KEY_SETTINGS:
        return _localizedValues[locale.languageCode][SETTINGS_NAVIGATION_TITLE];
      default:
        return '';
    }
  }

  String getHasCompletedMarkableDay(DateTime date) {
    if (locale.languageCode == 'ko') {
      return '${date.month}월 ${date.day}일에 먼저 완료 가능한 날이 있습니다. 순서대로 완료하지 않으면 연속 성공 횟수를 잃게됩니다.\n진행하시겠습니까?';
    } else {
      return 'You have a completable day at ${date.month}.${date.day}. You will lose current streak if you don\'t complete it orderly.\nProceed?';
    }
  }

  String getPetTitle(Pet pet) {
    return _localizedValues[locale.languageCode][pet.currentPhase.titleKey] ?? '';
  }

  String getPetSubtitle(Pet pet) {
    return _localizedValues[locale.languageCode][pet.currentPhase.subtitleKey] ?? '';
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