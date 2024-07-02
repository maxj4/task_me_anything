import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/ui/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/ui/widgets/task_timer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool displayDone = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
                displayDone ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              displayDone = !displayDone;
            },
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: prefer_const_constructors
            TaskTimer(),
            const SizedBox(height: 32),
            // TODO: replace nested FutureBuilder with Consumer
            //    e.g. by adding new method to TaskProvider that returns
            //    an object { tasks: List<Task>, focussedTaskId: int }
            FutureBuilder<List<Task>>(
              future: taskProvider.getTasks(),
              builder: (context, snapshot) {
                var tasks = snapshot.data ?? [];
                if (!displayDone) {
                  tasks = tasks.where((task) => !task.isDone).toList();
                }
                return FutureBuilder(
                  future: taskProvider.getFocussedTask(),
                  builder: (context, snapshot) {
                    var focussedTaskId = snapshot.data?.id ?? -1;
                    return TaskList(
                      tasks: tasks,
                      focussedTaskId: focussedTaskId,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
