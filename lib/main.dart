import 'package:task_me_anything/providers/locale_provider.dart';
import 'package:task_me_anything/providers/task_provider.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/repositories/task_repository.dart';
import 'package:task_me_anything/repositories/task_repository_impl.dart';
import 'package:task_me_anything/services/task_service.dart';
import 'package:task_me_anything/shared/router_config.dart';
import 'package:task_me_anything/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:task_me_anything/utils/db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();
  final DbHelper dbHelper = DbHelper();
  final TaskRepository taskRepository = TaskRepositoryImpl(dbHelper);
  final TaskService taskService = TaskService(taskRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider(taskService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task Me Anything',
      debugShowCheckedModeBanner: false,
      // l10n
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // locale and theme using providers
      locale: Provider.of<LocaleProvider>(context).locale,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      // go_router
      routerConfig: router,
    );
  }
}
