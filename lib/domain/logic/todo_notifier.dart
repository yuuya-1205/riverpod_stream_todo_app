import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/model/todo.dart';

// Provider定義
final todoNotifierProvider = StreamNotifierProvider<TodoNotifier, List<Todo>>(
  () => TodoNotifier(),
);

class TodoNotifier extends StreamNotifier<List<Todo>> {
  @override
  Stream<List<Todo>> build() {
    final stream = ref.watch(todoRepositoryProvider).fetchTodos();
    return stream.map(
      // TodoDtoをTodoに変換する
      (todos) => todos.map((todo) => Todo(title: todo.title)).toList(),
    );
  }

  // Todoを追加するメソッド
  Future<void> addTodo(String title) async {
    await ref.read(todoRepositoryProvider).addTodo(title);
  }
}
