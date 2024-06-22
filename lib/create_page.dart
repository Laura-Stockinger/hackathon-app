import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'models/Task.dart';

class CreatePage extends StatefulWidget {

  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => TaskFormState();
}

class TaskFormState extends State<CreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New Todo'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name'
            ),
            controller: nameController,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Description'
            ),
            controller: descriptionController,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Category'
            ),
            controller: categoryController,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = Task(
            name: nameController.text,
            description: descriptionController.text,
            isDone: false,
            category: categoryController.text,
            deadline: TemporalDate.now(),
          );
          final request = ModelMutations.create(newTask);
          final response = await Amplify.API.mutate(request: request).response;
          if (response.hasErrors) {
            safePrint('Creating task failed.');
          } else {
            safePrint('Creating task successful.');
          }
          Navigator.pop(context);
        },
        tooltip: 'Add task',
        child: const Icon(Icons.check),
      ),
    );
  }
}
