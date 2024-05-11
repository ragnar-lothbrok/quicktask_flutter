import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/task_list.dart';
import 'package:flutter_demo/services/task_service.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  TaskService taskService = TaskService();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Task task = data['task'] as Task;

    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              alignment: Alignment.center,
              child: TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: task.dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != task.dueDate) {
                    setState(() {
                      task.dueDate =
                          DateTime(picked.year, picked.month, picked.day);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Due Date'),
                    Text(DateFormat('dd-MM-yyyy').format(task.dueDate)),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              alignment: Alignment.center,
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            //add for checkbox
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              alignment: Alignment.center,
              child: CheckboxListTile(
                title: const Text('Completed'),
                value: task.completed,
                onChanged: (bool? value) {
                  setState(() {
                    task.completed = value!;
                  });
                },
              ),
            ),

            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  task.title = _titleController.text;
                  task.description = _descriptionController.text;
                  await taskService.save(task);
                  if (mounted) {
                    Navigator.of(context).pop(task);
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
