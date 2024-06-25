import 'package:flutter/material.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService;
  List<Task> _tasks = [];

  TaskProvider(this._taskService) {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  Future<void> _loadTasks() async {
    _tasks = await _taskService.getTasks();
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

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    await _loadTasks();
  }
}
