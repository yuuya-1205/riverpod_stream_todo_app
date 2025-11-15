import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/logic/todo_notifier.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Consumer(
        builder: (context, ref, child) {
          final stream = ref.watch(todoNotifierProvider).value;
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: stream?.length ?? 0,
                itemBuilder: (context, index) {
                  return Text(stream?[index].title ?? '');
                },
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(todoNotifierProvider.notifier).addTodo('test');
                },
                child: const Text('add Todo'),
              ),
            ],
          );
        },
      ),
    );
  }
}
