import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/repositories/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  Future<List<Task>> getTasks() => _taskRepository.getTasks();

  Future<void> addTask(Task task) => _taskRepository.addTask(task);

  Future<void> deleteTask(int id) => _taskRepository.deleteTask(id);
}
