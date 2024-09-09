import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/repositories/task_repository.dart';

class TaskService {
  static const String _focussedTaskKey = 'focussedTask';
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  Future<List<Task>> getTasks() => _taskRepository.getTasks();

  Future<void> addTask(Task task) => _taskRepository.addTask(task);

  Future<void> editTaskContent(int id, String content) =>
      _taskRepository.editTaskContent(id, content);

  Future<void> deleteTask(int id) => _taskRepository.deleteTask(id);

  Future<void> toggleIsDone(int id) => _taskRepository.toggleIsDone(id);

  Future<void> logTime({required int id, required int minutes}) =>
      _taskRepository.logTime(id: id, minutes: minutes);

  Future<void> setFocussedTask(int id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == -1) {
      await prefs.remove(_focussedTaskKey);
    } else {
      await prefs.setInt(_focussedTaskKey, id);
    }
  }

  Future<Task?> getFocussedTask() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_focussedTaskKey) ?? -1;
    if (id == -1) {
      return null;
    } else {
      final task = await _taskRepository.getTaskById(id);
      return task;
    }
  }
}
