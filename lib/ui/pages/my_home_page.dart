import 'package:task_me_anything/providers/locale_provider.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/services/notification_service.dart';
import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Flutter Template'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.loc.helloWorld('Flutter')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<LocaleProvider>().toggleLocale();
              },
              child: Text(context.loc.toggleLocale),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
              child: Text(context.loc.toggleTheme),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/example');
              },
              child: Text(context.loc.navExampleGo),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService.showNotification(
                    title: context.loc.notifTitle, body: context.loc.notifBody);
              },
              child: Text(context.loc.notifExample),
            ),
          ],
        ),
      ),
    );
  }
}
