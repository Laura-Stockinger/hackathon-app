import 'package:flutter/material.dart';
import 'models/Task.dart';

class TaskPage extends StatelessWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Name: ${task.name}'),
            Text('Description: ${task.description}'),
            Text('Category: ${task.category}'),
            Text('Deadline: ${task.deadline}'),
          ],
        ),
      ),
    );
  }
}
