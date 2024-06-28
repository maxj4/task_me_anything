import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/repositories/task_repository.dart';
import 'package:task_me_anything/utils/db_helper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DbHelper _dbHelper;

  TaskRepositoryImpl(this._dbHelper);

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await _dbHelper.queryAllRows();
    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _dbHelper.insert(task.toMap());
  }

  @override
  Future<void> deleteTask(int id) async {
    await _dbHelper.delete(id);
  }

  @override
  Future<void> toggleIsDone(int id) async {
    final task = await _dbHelper.queryById(id);
    await _dbHelper.update(Task.fromMap(task)
        .copyWith(isDone: !Task.fromMap(task).isDone)
        .toMap());
  }

  @override
  Future<void> logTime({required int id, required int minutes}) async {
    final task = await _dbHelper.queryById(id);
    await _dbHelper.update(Task.fromMap(task)
        .copyWith(
            timeSpentInMinutes: Task.fromMap(task).timeSpentInMinutes + minutes)
        .toMap());
  }
}
