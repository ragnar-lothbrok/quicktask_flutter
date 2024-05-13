import 'package:flutter/material.dart';
import 'routing/app_router.dart';

//Parse Server Configuration
const applicationId = '9RqhvlrNY7uSuhVOi7vZb3957u1lNp0xppvJpbtc';
const clientKey = 'EaFu9898x45tYDzZYJT0oXUtPeoJuc6KU0b49szy';
const parseURL = 'https://parseapi.back4app.com';

void main() {
  runApp(MyApp(router: AppRouter()));
}

//Main App
class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickTask',
      onGenerateRoute: router.generateRoute,
      routes: router.routes,
    );
  }
}
