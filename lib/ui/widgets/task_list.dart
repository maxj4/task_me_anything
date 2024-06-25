import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/providers/task_provider.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TextEditingController addTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Flexible(
      child: FractionallySizedBox(
        heightFactor: 0.5,
        widthFactor: 0.66,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addTaskController,
                      decoration: const InputDecoration(
                        labelText: 'Add a task',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (content) async {
                        if (content.isNotEmpty) {
                          await taskProvider.addTask(Task(
                            content: content,
                          ));
                          addTaskController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final String content = addTaskController.text;
                      if (content.isEmpty) {
                        return;
                      }
                      await taskProvider.addTask(Task(
                        content: content,
                      ));
                      addTaskController.clear();
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  return TaskWidget(task: widget.tasks[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '#${task.id} ${task.content}',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await taskProvider.deleteTask(task.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                // TODO avoid async gaps
                const SnackBar(
                  content: Text('Task deleted'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
