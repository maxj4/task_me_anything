import 'package:mockito/annotations.dart';
import 'package:task_me_anything/repositories/task_repository.dart';
import 'package:task_me_anything/services/task_service.dart';

@GenerateMocks([
  TaskRepository,
  TaskService,
])
void main() {}
