import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier_provider_riverpod/to_do.dart';
import 'package:state_notifier_provider_riverpod/to_do_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

final addTodoKey = UniqueKey();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListView(),
    );
  }
}

class TodoListView extends ConsumerWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todosProvider);
    final newTodoController = TextEditingController();
    const _uuid = Uuid();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          const Title(),
          TextField(
            key: addTodoKey,
            controller: newTodoController,
            decoration: const InputDecoration(
              labelText: 'What needs to be done?',
            ),
            onSubmitted: (value) {
              ref.read(todosProvider.notifier).addTodo(
                    Todo(
                      id: _uuid.v4(),
                      description: value,
                      completed: false,
                    ),
                  );
              newTodoController.clear();
            },
          ),
          for (final todo in todos) ...[
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: todo.completed,
                    onChanged: (value) =>
                        ref.read(todosProvider.notifier).toggle(todo.id),
                    title: Text(
                      todo.description,
                      style: TextStyle(
                        decoration: todo.completed == true ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(todosProvider.notifier).removeTodo(todo.id);
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}
