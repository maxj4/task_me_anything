import 'package:flutter/gestures.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/models/task.dart';
import 'package:task_me_anything/ui/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/ui/widgets/task_timer.dart';
import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool displayDone = false;

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw ('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(context.loc.aboutTitle),
                  content: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: context.loc.aboutContent,
                        ),
                        TextSpan(
                          text: 'GitHub',
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(Uri(
                                scheme: 'https',
                                host: 'github.com',
                                path: '/maxj4',
                              ));
                            },
                        ),
                        TextSpan(text: context.loc.aboutIconCredits),
                        TextSpan(
                          text: ('Flaticon Roundicons Premium.'),
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(Uri(
                                  scheme: 'https',
                                  host: 'www.flaticon.com',
                                  path: '/free-icon/hourglass_615290',
                                  query: 'term=hourglass&related_id=615290'));
                            },
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(context.loc.close),
                    ),
                  ],
                );
              },
            );
          },
        ),
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
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    widthFactor: 0.75,
                    child: FutureBuilder<TaskData>(
                      future: taskProvider.getTaskData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        TaskData taskData = snapshot.data!;
                        List<Task> tasks = taskData.tasks;

                        if (!displayDone) {
                          tasks = tasks.where((task) => !task.isDone).toList();
                        }

                        return TaskList(
                          tasks: tasks,
                          focussedTaskId: taskData.focussedTaskId,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
