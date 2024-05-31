import 'package:task_me_anything/utils/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavExamplePage extends StatelessWidget {
  const NavExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Example'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(context.loc.navExampleBack),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
    );
  }
}
