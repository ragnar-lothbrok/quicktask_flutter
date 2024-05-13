import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/helper_service.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';
import 'package:flutter_demo/services/task_service.dart';

class Task {
  String? id;
  String title = '';
  DateTime dueDate = DateTime.now();
  bool completed = false;
  String? description = '';
  Task({
    required this.title,
    required this.dueDate,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  TaskService taskService = TaskService();
  HelperService helperService = HelperService();

  //fetch tasks from the server
  Future<void> fetch() async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      ParseUser user = await ParseUser.currentUser();

      final queryBuilder = QueryBuilder(ParseObject('Tasks'))
        ..whereEqualTo('user', user.username)
        ..orderByDescending('dueDate');
      final response = await queryBuilder.query();
      List<Task> results = [];
      if (response.success && response.results != null) {
        for (var o in response.results!) {
          Task task = Task(title: o['title'], dueDate: o['dueDate']);
          task.id = o['objectId'];
          task.description = o['description'];
          task.completed = o['completed'];
          results.add(task);
        }
      }
      setState(() {
        tasks = results;
      });
    } catch (e) {
      // Handle error properly
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuickTask',
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).pushNamed(
                  '/view-details',
                  arguments: {'task': task},
                );
                await fetch();
              },
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                leading:
                    Icon(task.completed ? Icons.alarm_off_rounded : Icons.alarm,
                        color: task.completed
                            ? Colors.green
                            : DateTime.now().compareTo(task.dueDate) > 0
                                ? Colors.red
                                : Colors.black),
                title: Text(task.title),
                subtitle: Text(task.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //toggle task status
                    IconButton(
                      tooltip: DateFormat('dd-MM-yyyy').format(task.dueDate),
                      icon: Icon(
                          task.completed
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: task.completed
                              ? Colors.green
                              : DateTime.now().compareTo(task.dueDate) > 0
                                  ? Colors.red
                                  : Colors.black),
                      onPressed: () async {
                        task.completed = !task.completed;
                        TaskService taskService = TaskService();
                        bool success = await taskService.save(task);
                        // helperService.showMessage(context,
                        //     'Task ${task.title} is marked ${task.completed ? 'Completed' : 'Incompleted'}!');
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Success',
                          desc:
                              'Task ${task.title} is marked ${task.completed ? 'Completed' : 'Incompleted'}!',
                        ).show();
                        if (success) {
                          await fetch();
                        }
                      },
                    ),
                    IconButton(
                      tooltip: DateFormat('dd-MM-yyyy').format(task.dueDate),
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        bool success = await taskService.delete(task.id!);
                        // helperService.showMessage(context,
                        //     '${task.completed ? 'Completed' : 'Incompleted'}Task ${task.title} is deleted successfully!');
                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Success',
                          desc:
                              '${task.completed ? 'Completed' : 'Incompleted'}Task ${task.title} is deleted successfully!',
                        ).show();
                        if (success) {
                          await fetch();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  '/',
                );
                await fetch();
              },
              child: const Icon(Icons.home),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  '/view-details',
                  arguments: {'task': Task(title: '', dueDate: DateTime.now())},
                );
                await fetch();
              },
              child: const Icon(Icons.add),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                final ParseUser parseUser = await ParseUser.currentUser();
                final result = await parseUser.logout();
                if (result.success) {
                  // helperService.showMessage(context, 'Logout Successful.');
                  await AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Logout Success',
                    desc: 'You have successfully logged out.',
                  ).show();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                } else {
                  helperService.showMessage(context, 'Error logging out',
                      error: true);
                }
              },
              child: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
