import 'package:task_me_anything/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task?> getTaskById(int id);
  Future<void> addTask(Task task);
  Future<void> editTaskContent(int id, String content);
  Future<void> deleteTask(int id);
  Future<void> toggleIsDone(int id);
  Future<void> logTime({required int id, required int minutes});
}
