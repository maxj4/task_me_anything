import 'package:flutter/material.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService;
  List<Task> _tasks = [];

  TaskProvider._(this._taskService) {
    _loadTasks();
  }

  static TaskProvider? _instance;

  factory TaskProvider(TaskService taskService) {
    _instance ??= TaskProvider._(taskService);
    return _instance!;
  }

  List<Task> get tasks => _tasks;

  Future<void> _loadTasks() async {
    _tasks = await _taskService.getTasks();
    int focussedTaskId = (await getFocussedTask())?.id ?? -1;
    if (focussedTaskId != -1) {
      _moveFocussedTaskToTop(focussedTaskId);
    }
    notifyListeners();
  }

  Future<List<Task>>? getTasks() async {
    await _loadTasks();
    return _tasks;
  }

  Future<void> addTask(Task task) async {
    await _taskService.addTask(task);
    await _loadTasks();
  }

  Future<void> editTaskContent(int id, String content) async {
    await _taskService.editTaskContent(id, content);
    await _loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    await _loadTasks();
  }

  Future<void> toggleIsDone(int id) async {
    await _taskService.toggleIsDone(id);
    await _loadTasks();
  }

  Future<void> logTime({required int id, required int minutes}) async {
    await _taskService.logTime(id: id, minutes: minutes);
    await _loadTasks();
  }

  Future<void> setFocussedTask(int id) async {
    await _taskService.setFocussedTask(id);
    await _loadTasks();
  }

  Future<Task?> getFocussedTask() async {
    return await _taskService.getFocussedTask();
  }

  Future<TaskData> getTaskData() async {
    return TaskData(
      tasks: tasks,
      focussedTaskId: (await getFocussedTask())?.id ?? -1,
    );
  }

  void _moveFocussedTaskToTop(int focussedTaskId) {
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].id == focussedTaskId) {
        Task focussedTask = _tasks.removeAt(i);
        _tasks.insert(0, focussedTask);
        break;
      }
    }
  }
}
