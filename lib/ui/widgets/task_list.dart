import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final int? focussedTaskId;

  const TaskList(
      {super.key, required this.tasks, required this.focussedTaskId});

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
        heightFactor: 0.75,
        widthFactor: 0.75,
        child: Column(
          children: [
            Container(
              decoration: taskListBoxDecoration(theme),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addTaskController,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: context.loc.addTask,
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
                  return TaskWidget(
                    task: widget.tasks[index],
                    focussedTaskId: widget.focussedTaskId,
                  );
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
  final Task task;
  final int? focussedTaskId;
  final TextEditingController timeSpentController = TextEditingController();

  TaskWidget({
    super.key,
    required this.task,
    required this.focussedTaskId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    final bool isFocussed = task.id == focussedTaskId;

    return Container(
      decoration: taskListBoxDecoration(theme),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Column(
            children: [
              Text('#${task.id}'),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Text(
                    _getDisplayTime(task.timeSpentInMinutes),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              '${task.content}',
              style: theme.textTheme.bodyLarge!.copyWith(
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone
                      ? theme.colorScheme.onSurface.withOpacity(0.6)
                      : null),
            ),
          ),
          IconButton(
            icon: Icon(isFocussed ? Icons.star : Icons.star_border),
            onPressed: () async {
              int id = isFocussed ? -1 : task.id!;
              await taskProvider.setFocussedTask(id);
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Log Time'),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(context.loc.timeSpent),
                          content: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: timeSpentController,
                                decoration: InputDecoration(
                                  labelText: context.loc.minutes,
                                ),
                                keyboardType: TextInputType.number,
                                onSubmitted: (_) async {
                                  FocusScope.of(context).unfocus();
                                },
                              ))
                            ],
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(24, 24, 24, 12),
                          actions: [
                            TextButton(
                              child: Text(context.loc.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(context.loc.ok),
                              onPressed: () async {
                                int timeSpent =
                                    int.tryParse(timeSpentController.text) ?? 0;
                                Navigator.of(context).pop();
                                await taskProvider.logTime(
                                    id: task.id!, minutes: timeSpent);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(task.isDone
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                    title: const Text('Toggle Done'),
                  ),
                  onTap: () async {
                    await taskProvider.toggleIsDone(task.id!);
                  },
                ),
                PopupMenuItem(
                  child: const ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(context.loc.confirmDelete),
                          contentPadding:
                              const EdgeInsets.fromLTRB(24, 24, 24, 12),
                          actions: [
                            TextButton(
                              child: Text(context.loc.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(context.loc.delete),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await taskProvider.deleteTask(task.id!);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.loc.taskDeleted),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

BoxDecoration taskListBoxDecoration(ThemeData theme) {
  return BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: theme.colorScheme.shadow.withOpacity(0.2),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

String _getDisplayTime(int minutes) {
  if (minutes < 60) {
    return '$minutes\'\'';
  } else {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '$hours\' $remainingMinutes\'\'';
  }
}
