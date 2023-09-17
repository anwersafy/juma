import 'package:geolocator/geolocator.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}
class AppChangeBottomNavBarState extends AppStates {}


class AppChangeModeState extends AppStates {}

class AppGetLocationState extends AppStates {}

class AppGetLocationSuccessState extends AppStates {
  final String? address;
  final Position? position;

  AppGetLocationSuccessState({this.address, this.position});
}

class AppGetLocationErrorState extends AppStates {
  final String? error;

  AppGetLocationErrorState(this.error);
}

class AppGetPrayerTimeState extends AppStates {}

class AppGetPrayerTimeSuccessState extends AppStates {
  final String? fajr;
  final String? sunrise;
  final String? dhuhr;
  final String? asr;
  final String? sunset;
  final String? maghrib;
  final String? isha;

  AppGetPrayerTimeSuccessState(
      {this.fajr,
        this.sunrise,
        this.dhuhr,
        this.asr,
        this.maghrib,
        this.sunset,
        this.isha});
}

class AppGetPrayerTimeErrorState extends AppStates {
  final String? error;

  AppGetPrayerTimeErrorState(this.error);
}

class AppGetPrayerTimeLoadingState extends AppStates {}

class AppGetPrayerTimeLoadingSuccessState extends AppStates {}

class AppGetPrayerTimeLoadingErrorState extends AppStates {
  final String? error;

  AppGetPrayerTimeLoadingErrorState(this.error);
}

class AppLocationPermissionState extends AppStates{}
class AppLocationPermissionSuccessState extends AppStates{}
class AppLocationPermissionErrorState extends AppStates{}


class AppLocationState extends AppStates{}
class AppLocationSuccessState extends AppStates{}
class AppLocationErrorState extends AppStates{}

class AppGetPrayerHourSuccessState extends AppStates {
  final List prayerHours;

  AppGetPrayerHourSuccessState(this.prayerHours);
}
class AppDefaultPrayerTimeSuccessState extends AppStates {}

class AppGetPrayerHourErrorState extends AppStates {
  final String? error;

  AppGetPrayerHourErrorState(this.error);
}
class AppGetPrayerHourLoadingState extends AppStates {}

class AppGetNightThirdSuccessState extends AppStates {
  final List prayerHours;

  AppGetNightThirdSuccessState(this.prayerHours);
}
class AppGetNightThirdErrorState extends AppStates {
  final String? error;

  AppGetNightThirdErrorState(this.error);
}
class AppGetNightThirdLoadingState extends AppStates {}

class AppStartCountDownSuccessState extends AppStates {}
class AppStartCountDownErrorState extends AppStates {
  final String? error;

  AppStartCountDownErrorState(this.error);
}
class AppChangeLanguageState extends AppStates {}
class AppRadioState extends AppStates {}
class AppStopCountDownSuccessState extends AppStates {}
class AppResetCountDownSuccessState extends AppStates {}
class AppSetCountDownSuccessState extends AppStates {}
class AppCounterSuccessState extends AppStates {}
class InitializeNotificationState extends AppStates {}
class OnSelectNotificationState extends AppStates {}

class CancelNotificationState extends AppStates {}
class CancelAllNotificationState extends AppStates {}
class ScheduleNotificationState extends AppStates {}
class RequestIOSPermissionState extends AppStates {}
class RequestIOSPermissionSuccessState extends AppStates {}
class RequestIOSPermissionErrorState extends AppStates {}
class ScheduledNotificationState extends AppStates {}
class SetTimeNotificationState extends AppStates {}


class OnDidReceiveLocalNotificationResponseState extends AppStates {}
class ScheduledNotificationLoadingState extends AppStates {}
class ScheduledNotificationSuccessState extends AppStates {}
class ScheduledNotificationErrorState extends AppStates {
  final String error;

  ScheduledNotificationErrorState(this.error);
}
class ScheduledNotificationLoadedState extends AppStates {}
class NotificationSecheduledState extends AppStates {}
class ShowNotificationState extends AppStates {}
class ShowNotificationLoadingState extends AppStates {}
class ShowNotificationSuccessState extends AppStates {}
class ShowNotificationErrorState extends AppStates {
  final String error;

  ShowNotificationErrorState(this.error);
}
class SendFirebaseNotificationState extends AppStates {}
class SendFirebaseNotificationLoadingState extends AppStates {}
class SendFirebaseNotificationSuccessState extends AppStates {}
class SendFirebaseNotificationErrorState extends AppStates {
  final String error;

  SendFirebaseNotificationErrorState(this.error);
}
class PermissionNotGrantedState extends AppStates {}
class PermissionGrantedState extends AppStates {}
class PermissionDeniedState extends AppStates {}
class SaveNetworkArImageState extends AppStates {}
class SaveNetworkEnImageState extends AppStates {}
class SurahElkahfNotificationState extends AppStates {}
class EarlyJoumaHourNotificationState extends AppStates {}
class NightPrayerNotificationState extends AppStates {}
class FastingMondayAndThursdayNotificationState extends AppStates {}
class MornPrayerNotificationState extends AppStates {}
class AzkarNotificationState extends AppStates {}
class AzanNotificationState extends AppStates {}
class PrayOnProphetNotificationState extends AppStates {}
class PrayerTimeApproachingNotificationState extends AppStates {}
class LastHourFridayNotificationState extends AppStates {}
class WhiteDaysNotificationState extends AppStates {}
class QuranNotificationState extends AppStates {}
class DailyQuranNotificationState extends AppStates {}
class CancelSurahElKahfNotificationState extends AppStates {}
class CancelEarlyJoumaHourNotificationState extends AppStates {}
class CancelNightPrayerNotificationState extends AppStates {}
class CancelFastingMondayAndThursdayNotificationState extends AppStates {}
class CancelMornPrayerNotificationState extends AppStates {}
class CancelAzkarNotificationState extends AppStates {}
class CancelAzanNotificationState extends AppStates {}
class CancelPrayerTimeApproachingNotificationState extends AppStates {}
class CancelQuranNotificationState extends AppStates {}
class CancelLastHourFridayNotificationState extends AppStates {}
class CancelPrayOnProphetNotificationState extends AppStates {}
class CancelWhiteDaysNotificationState extends AppStates {}
class CancelDailyQuranNotificationState extends AppStates {}
class TurnOnAllNotificationState extends AppStates {}
class GetAdminMassageEnFromFirebaseState extends AppStates {}
class GetAdminMassageArFromFirebaseState extends AppStates {}
class GetJoumaaHadithArFromFirebaseState extends AppStates{}
class GetJoumaaHadithEnFromFirebaseState extends AppStates{}
class GetJoumaaSunnin1FromFirebaseState extends AppStates{}
class GetJoumaaSunnin2FromFirebaseState extends AppStates{}
class GetJoumaaSunnin3FromFirebaseState extends AppStates{}
class GetNightHadithArFromFirebaseState extends AppStates{}
class GetNightHadithEnFromFirebaseState extends AppStates{}
class GetAllFromFirebaseState extends AppStates{}
class InternertConectionState extends AppStates{}
class NoInternetConnectionState extends AppStates{}
class InitAppState extends AppStates{}
class GetImageFromFirebaseStorageState extends AppStates{}
class GetImageFromFirebaseStorageSuccessState extends AppStates{}
class GetJoumaaSunnin1FromFirebaseENState extends AppStates{}
class GetJoumaaSunnin2FromFirebaseENState extends AppStates{}
class GetJoumaaSunnin3FromFirebaseENState extends AppStates{}
class GetImageFromFirebaseStorageEnState extends AppStates{}
class GetImageFromFirebaseStorageErrorState extends AppStates{}
class SetEqamaState extends AppStates{}
class SetAzanNotificationState extends AppStates{}
class CancelEqamaState extends AppStates{}
class SetDailyQuranNotificationState extends AppStates{}
class SetEqamaNotificationState extends AppStates{}
class SetPrayOnProphetNotificationState extends AppStates{}
class SetApproachingPrayersNotificationState extends AppStates{}
class SetMorningEveningNotificationState extends AppStates{}
class SetDuhaPrayerNotificationState extends AppStates{}
class SetNightPrayerNotificationState extends AppStates{}
class SetJoumaaHourNotificationState extends AppStates{}
class SetSurahElkahfNotificationState extends AppStates{}
class SetMondayThursdayNotificationState extends AppStates{}
class SetDoaaLastJoumaaHourNotificationState extends AppStates{}
