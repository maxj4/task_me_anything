import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/services/notification_service.dart';
import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';

class TaskTimer extends StatefulWidget {
  const TaskTimer({super.key});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  late TextEditingController _timeController;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(text: '20:00');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeController.dispose();
    super.dispose();
  }

  void _startTimer(TaskProvider taskProvider, int focussedTaskId) {
    if (!_isRunning) {
      _isRunning = true;
      int initialMinutes = _getSecondsFromDisplay() ~/ 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        int seconds = _getSecondsFromDisplay();
        if (seconds > 0) {
          seconds--;
          _updateDisplay(seconds);
        } else {
          _stopTimer();
          NotificationService.showAlarmNotification(
            title: context.loc.notifTitle,
            body: context.loc.notifBody,
          );
          if (focussedTaskId != -1) {
            await taskProvider.logTime(
                id: focussedTaskId, minutes: initialMinutes);
          }
        }
      });
    }
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    if (!_isRunning) {
      _stopTimer();
      _updateDisplay(20 * 60);
    }
  }

  int _getSecondsFromDisplay() {
    List<String> parts = _timeController.text.split(':');
    if (parts.length != 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void _updateDisplay(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    _timeController.text =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
            _TimeInputFormatter(),
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
              onPressed: () async {
                final Task? task = await taskProvider.getFocussedTask();
                final int id = task?.id ?? -1;
                _startTimer(taskProvider, id);
              },
              child: Text(context.loc.start),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _stopTimer,
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

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    int selectionIndex = newValue.selection.end;

    // Handle deletion
    if (newText.length < oldValue.text.length) {
      // Determine which digit was deleted
      int deletedIndex = oldValue.selection.end - 1;
      if (deletedIndex >= 0) {
        // Skip colon when deleting
        if (deletedIndex == 2) {
          deletedIndex = 1;
        }
        // Replace the deleted digit with '0'
        String updatedText =
            oldValue.text.replaceRange(deletedIndex, deletedIndex + 1, '0');

        // Adjust cursor position for deletion
        if (deletedIndex >= 3) {
          // If deleting digit after colon
          selectionIndex = deletedIndex;
        } else {
          // If deleting digit before colon
          selectionIndex = deletedIndex;
        }

        return TextEditingValue(
          text: updatedText,
          selection: TextSelection.collapsed(offset: selectionIndex),
        );
      }
    }

    // Remove all non-digit characters
    final digitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 4 digits
    final limitedDigits =
        digitsOnly.substring(0, math.min(4, digitsOnly.length));

    // Format the time
    final formattedValue = StringBuffer();
    for (int i = 0; i < 4; i++) {
      if (i == 2) formattedValue.write(':');
      formattedValue.write(i < limitedDigits.length ? limitedDigits[i] : '0');
    }

    // Adjust cursor position for insertion
    if (newText.length > oldValue.text.length) {
      if (selectionIndex > 2) selectionIndex++;
      if (selectionIndex > 5) selectionIndex = 5;
    }

    // If all digits were deleted, reset to "00:00"
    if (limitedDigits.isEmpty) {
      return const TextEditingValue(
        text: "00:00",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    return TextEditingValue(
      text: formattedValue.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
