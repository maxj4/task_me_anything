import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/services/task_service.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;
    late MockTaskService mockTaskService;

    setUp(() {
      mockTaskService = MockTaskService();
      taskProvider = TaskProvider(mockTaskService);
    });

    test('should add a task', () async {
      final task = Task(content: 'Task 1');
      await taskProvider.addTask(task);
      verify(mockTaskService.addTask(task));
    });

    test('should edit task content', () async {
      const taskId = 1;
      const newContent = 'Updated Task Content';
      await taskProvider.editTaskContent(taskId, newContent);
      verify(mockTaskService.editTaskContent(taskId, newContent));
    });

    test('should delete a task', () async {
      const taskId = 1;
      await taskProvider.deleteTask(taskId);
      verify(mockTaskService.deleteTask(taskId));
    });

    test('should toggle task isDone status', () async {
      const taskId = 1;
      await taskProvider.toggleIsDone(taskId);
      verify(mockTaskService.toggleIsDone(taskId));
    });

    test('should log time for a task', () async {
      const taskId = 1;
      const minutes = 30;
      await taskProvider.logTime(id: taskId, minutes: minutes);
      verify(mockTaskService.logTime(id: taskId, minutes: minutes));
    });

    test('should set focussed task', () async {
      const taskId = 1;
      await taskProvider.setFocussedTask(taskId);
      verify(mockTaskService.setFocussedTask(taskId));
    });

    test('should get focussed task', () async {
      final task = Task(id: 1, content: 'Task 1');
      when(mockTaskService.getFocussedTask()).thenAnswer((_) async => task);
      final focussedTask = await taskProvider.getFocussedTask();
      expect(focussedTask, task);
    });

    test('should move focussed task to top', () async {
      final task1 = Task(id: 1, content: 'Task 1');
      final task2 = Task(id: 2, content: 'Task 2');
      final task3 = Task(id: 3, content: 'Task 3');
      taskProvider.tasks.addAll([task1, task2, task3]);
      taskProvider._moveFocussedTaskToTop(2);
      expect(taskProvider.tasks.first.id, 2);
    });
  });
}
