import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_me_anything/providers/task_provider.dart';

// @GenerateNiceMocks([MockSpec<TaskService>()])
import '../helpers/test_helper.mocks.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;
    late MockTaskService mockTaskService;

    setUp(() async {
      mockTaskService = MockTaskService();

      when(mockTaskService.getTasks()).thenAnswer((_) async => []);
      when(mockTaskService.getFocussedTask()).thenAnswer((_) async => null);

      taskProvider = TaskProvider(mockTaskService);
    });

    tearDown(() {
      reset(mockTaskService);
    });

    test('should initialize with empty tasks', () async {
      verify(mockTaskService.getTasks()).called(1);
      verify(mockTaskService.getFocussedTask()).called(1);
      expect(taskProvider.tasks, []);
    });

    // TODO: Refactor the bullshit implementation of TaskProvider first!!!
  });
}
