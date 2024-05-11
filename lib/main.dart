import 'package:flutter/material.dart';
import 'routing/app_router.dart';

//Parse Server Configuration
const applicationId = '';
const clientKey = '';
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
      title: 'QuickTask - Task Management App',
      onGenerateRoute: router.generateRoute,
    );
  }
}
