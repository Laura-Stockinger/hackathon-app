import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'task_page.dart';

void main() {
  _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins(
      [
        AmplifyAPI(
          options: APIPluginOptions(
            modelProvider: ModelProvider.instance,
          ),
        ),
      ],
    );
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }
  
  Future<void> _refreshTasks() async {
  try {
    final request = ModelQueries.list(Task.classType);
    final response = await Amplify.API.query(request: request).response;

    final todos = response.data?.items;
    if (response.hasErrors) {
      safePrint('errors: ${response.errors}');
      return;
    }
    setState(() {
      _tasks = todos!.whereType<Task>().toList();
    });
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _tasks.isEmpty == true 
        ? const Center(child: Text('No tasks')) 
        : Center(
          child: ListView(
            children: _tasks.map((task) {
              return ListTile(
                title: Text(task.name!),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskPage(key: ValueKey(task.hashCode), task: task)),
                ),
              );
            }).toList(),	
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          safePrint("test");
          final newTask = Task(
            name: "Random Todo ${DateTime.now().toIso8601String()}",
            description: "bla bla",
            isDone: false,
            category: "General",
            deadline: TemporalDate.now(),
          );
          final request = ModelMutations.create(newTask);
          final response = await Amplify.API.mutate(request: request).response;
          if (response.hasErrors) {
            safePrint('Creating task failed.');
          } else {
            safePrint('Creating task successful.');
          }
          _refreshTasks();
        },
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
