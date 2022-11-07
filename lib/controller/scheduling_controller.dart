import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/background_service.dart';
import '../utils/date_time.dart';

class SchedulingController extends GetxController {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  @override
  void onInit() {
    getBool();
    super.onInit();
  }

  setBool(bool data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('schedule', data);
    update();
  }

  getBool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool('schedule') ?? false;
    update();
  }

  Future<bool> scheduledNews(bool value) async {
    setBool(value);
    _isScheduled = value;
    if (_isScheduled) {
      update();
      return await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      update();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
