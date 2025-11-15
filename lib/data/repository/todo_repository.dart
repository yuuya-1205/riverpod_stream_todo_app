import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/data/dto/todo_dto.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/firebase_firestore_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository(ref);
});

class TodoRepository {
  TodoRepository(this.ref);

  final Ref ref;

  Stream<List<TodoDto>> fetchTodos() {
    return ref
        .read(firebaseFirestoreProvider)
        .collection('todos')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TodoDto(title: doc.data()['title'] as String))
              .toList(),
        );
  }

  Future<void> addTodo(String title) async {
    await ref.read(firebaseFirestoreProvider).collection('todos').add({
      'title': title,
    });
  }
}
