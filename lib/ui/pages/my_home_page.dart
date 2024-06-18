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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
              child: Text(context.loc.toggleTheme),
            ),
          ],
        ),
      ),
    );
  }
}
