import 'package:flutter/material.dart';
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
          'QuickTask - Task Management App',
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
                leading: const Icon(Icons.alarm),
                title: Text(task.title),
                subtitle: Text(task.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //toggle task status
                    IconButton(
                      icon: Icon(task.completed
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onPressed: () async {
                        task.completed = !task.completed;
                        TaskService taskService = TaskService();
                        bool success = await taskService.save(task);
                        if (success) {
                          await fetch();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        bool success = await taskService.delete(task.id!);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(
            '/view-details',
            arguments: {'task': Task(title: '', dueDate: DateTime.now())},
          );
          await fetch();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
