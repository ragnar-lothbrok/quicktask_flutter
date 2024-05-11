import 'package:flutter/material.dart';

import 'package:flutter_demo/screens/home.dart';
import 'package:flutter_demo/screens/login.dart';
import 'package:flutter_demo/screens/task_details.dart';
import 'package:flutter_demo/screens/task_list.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case Routes.taskDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => const TaskDetails(),
        );
      case Routes.taskScreen:
        return MaterialPageRoute(
          builder: (_) => const TaskList(),
        );
    }
    return null;
  }

  Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const Home(),
      '/login': (context) => const Login(),
      '/tasks': (context) => const TaskList(),
      '/view-details': (context) => const TaskDetails(),
    };
  }
}
