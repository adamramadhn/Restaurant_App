import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/scheduling_controller.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';
  static const routeName = '/setting';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListTile(
          title: const Text('Scheduling News Restaurant'),
          trailing: GetBuilder<SchedulingController>(
            init: SchedulingController(),
            builder: (scheduled) {
              return Switch(
                value: scheduled.isScheduled,
                onChanged: (value) async {
                  scheduled.scheduledNews(value);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
