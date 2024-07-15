// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/services/notification_service.dart';
import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';
import 'package:task_me_anything/utils/time_input_formatter.dart';

class TaskTimer extends StatefulWidget {
  const TaskTimer({super.key});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> with WidgetsBindingObserver {
  static const String scheduledTimeKey = 'scheduledTime';
  // always use the same id for the alarm to avoid multiple alarms
  static const int alarmId = 0;
  late TextEditingController _timeController;
  late SharedPreferences _prefs;
  Timer? _timer;
  int? _scheduledTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestAlarmPermission();
    _timeController = TextEditingController(text: '20:00');
    _initPrefsAndUpdate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _timer?.cancel();
        break;
      case AppLifecycleState.resumed:
        _scheduledTime = _prefs.getInt(scheduledTimeKey);
        _updateDisplayAndRuntTimer();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isRunning = false;
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _requestAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.alarmPermissionDenied)),
        );
      }
    }
  }

  void _initPrefsAndUpdate() async {
    _prefs = await SharedPreferences.getInstance();
    _scheduledTime = _prefs.getInt(scheduledTimeKey);
    _updateDisplayAndRuntTimer();
  }

  void _updateDisplayAndRuntTimer() {
    int? seconds = _scheduledTime != null
        ? (_scheduledTime! - DateTime.now().millisecondsSinceEpoch) ~/ 1000
        : null;

    if (seconds != null) {
      if (seconds < 0) {
        seconds = 0;
      }
      _updateDisplay(seconds);
      _runTimer(seconds);
    }
  }

  void _updateDisplay(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    _timeController.text =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _runTimer(int remainingTimeInSeconds) {
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingTimeInSeconds > 0) {
          remainingTimeInSeconds--;
          setState(() {
            _updateDisplay(remainingTimeInSeconds);
          });
        } else {
          _isRunning = false;
          _timer?.cancel();
        }
      },
    );
  }

  Future<void> _setAlarmAndRunTimer(
      TaskProvider taskProvider, int focussedTaskId) async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      if (!_isRunning) {
        _isRunning = true;
        int initialSeconds = _getSecondsFromDisplay();
        final DateTime scheduledTime =
            DateTime.now().add(Duration(seconds: initialSeconds));

        _prefs.setInt(scheduledTimeKey, scheduledTime.millisecondsSinceEpoch);

        await AndroidAlarmManager.oneShotAt(
          scheduledTime,
          alarmId,
          notifyAlarmFinished,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );

        _runTimer(initialSeconds);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.alarmPermissionDenied)),
        );
      }
    }
  }

  int _getSecondsFromDisplay() {
    List<String> parts = _timeController.text.split(':');
    if (parts.length != 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void _pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
    AndroidAlarmManager.cancel(alarmId);
    _prefs.remove(scheduledTimeKey);
  }

  void _resetTimer() {
    if (!_isRunning) {
      _pauseTimer();
      _updateDisplay(20 * 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Column(
      children: [
        TextFormField(
          controller: _timeController,
          style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            TimeInputFormatter(),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '00:00',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          enabled: !_isRunning,
          maxLength: 5,
          buildCounter: (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) =>
              null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRunning || _getSecondsFromDisplay() == 0
                  ? null
                  : () async {
                      final Task? task = await taskProvider.getFocussedTask();
                      final int id = task?.id ?? -1;
                      _setAlarmAndRunTimer(taskProvider, id);
                    },
              child: Text(context.loc.start),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _isRunning ? _pauseTimer : null,
              child: Text(context.loc.pause),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _isRunning ? null : _resetTimer,
              child: Text(context.loc.reset),
            ),
          ],
        ),
      ],
    );
  }
}

@pragma('vm:entry-point')
void notifyAlarmFinished() async {
  NotificationService.showAlarmNotification(
    title: 'Timer finished!',
    body: 'Time to take a break! 🎉',
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('scheduledTime');
}
