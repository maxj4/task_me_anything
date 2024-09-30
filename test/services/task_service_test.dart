import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/services/task_service.dart';

import '../helpers/test_helper.mocks.dart';

const focussedTaskKey = 'focussedTask';

void main() {
  group('TaskService Tests', () {
    late TaskService taskService;
    late MockTaskRepository mockTaskRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      taskService = TaskService(mockTaskRepository);
    });

    test('should fetch tasks', () async {
      when(mockTaskRepository.getTasks()).thenAnswer((_) async => []);
      final tasks = await taskService.getTasks();
      expect(tasks, isEmpty);
    });

    test('should add a task', () async {
      final task = Task(content: 'Task 1');
      await taskService.addTask(task);
      verify(mockTaskRepository.addTask(task));
    });

    test('should edit task content', () async {
      const taskId = 1;
      const newContent = 'Updated Task Content';
      await taskService.editTaskContent(taskId, newContent);
      verify(mockTaskRepository.editTaskContent(taskId, newContent));
    });

    test('should delete a task', () async {
      const taskId = 1;
      await taskService.deleteTask(taskId);
      verify(mockTaskRepository.deleteTask(taskId));
    });

    test('should toggle task isDone status', () async {
      const taskId = 1;
      await taskService.toggleIsDone(taskId);
      verify(mockTaskRepository.toggleIsDone(taskId));
    });

    test('should log time for a task', () async {
      const taskId = 1;
      const minutes = 30;
      await taskService.logTime(id: taskId, minutes: minutes);
      verify(mockTaskRepository.logTime(id: taskId, minutes: minutes));
    });

    test('should set focussed task', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const taskId = 1;

      await taskService.setFocussedTask(taskId);

      expect(prefs.getInt(focussedTaskKey), taskId);
    });

    test('should remove focussed task', () async {
      SharedPreferences.setMockInitialValues({focussedTaskKey: 1});
      final prefs = await SharedPreferences.getInstance();

      await taskService.setFocussedTask(-1);

      expect(prefs.getInt(focussedTaskKey), isNull);
    });

    test('should get focussed task', () async {
      SharedPreferences.setMockInitialValues({focussedTaskKey: 1});
      final task = Task(id: 1, content: 'Task 1');

      when(mockTaskRepository.getTaskById(1)).thenAnswer((_) async => task);

      final focussedTask = await taskService.getFocussedTask();

      expect(focussedTask, task);
    });
  });
}
