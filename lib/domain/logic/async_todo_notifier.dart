import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/model/todo.dart';

// Provider定義
final asyncTodoNotifierProvider =
    AsyncNotifierProvider<TodoNotifier, List<Todo>>(() => TodoNotifier());

class TodoNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final streamTodos = ref.watch(todoRepositoryProvider).fetchTodos();
    final todos = await streamTodos.first;
    return todos.map((todoDto) => Todo(title: todoDto.title)).toList();
  }

  // Todoを追加するメソッド
  Future<void> addTodo(String title) async {
    await ref.read(todoRepositoryProvider).addTodo(title);
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data([...currentState, Todo(title: title)]);
    }
  }
}
