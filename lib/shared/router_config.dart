import 'package:task_me_anything/constants.dart';
import 'package:task_me_anything/ui/pages/my_home_page.dart';
import 'package:task_me_anything/ui/pages/nav_example_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
// used for nested routes
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: homeRoute,
  routes: [
    GoRoute(
      path: homeRoute,
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: exampleRoute,
      builder: (context, state) => const NavExamplePage(),
    )
    // Use ShellRoute for nested routes, e.g. to keep a BottomNavigationBar on the screen and
    // only navigate the content area (body) of the screen.
    // ShellRoute(
    //   navigatorKey: _shellNavigatorKey,
    //   builder: (context, state, child) => Scaffold(
    //       appBar: AppBar(
    //         title: const Text('Basic Flutter Template'),
    //       ),
    //       body: child,
    //       bottomNavigationBar: BottomNavigationBar(
    //         items: const [
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.home),
    //             label: 'Home',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.settings),
    //             label: 'Settings',
    //           ),
    //         ],
    //         onTap: (index) {
    //           if (index == 0) {
    //             context.push(homeRoute);
    //           } else {
    //             context.push('/nested');
    //           }
    //         },
    //       )),
    //   routes: [
    //     GoRoute(
    //       path: '/nested',
    //       builder: (context, state) => const NestedPage(),
    //     ),
    //   ],
    // )
  ],
);
