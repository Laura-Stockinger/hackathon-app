import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final request = ModelMutations.delete(task);
          final response = await Amplify.API.mutate(request: request).response;
          if (response.hasErrors) {
            safePrint('Deleting task failed.');
          } else {
            safePrint('Deleting task successful.');
          }
          Navigator.pop(context);
        },
        tooltip: 'Delete task',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
