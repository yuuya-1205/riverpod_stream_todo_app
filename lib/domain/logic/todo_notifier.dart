import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/data/dto/todo_dto.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/firebase_firestore_repository.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';

// Provider定義
final todoNotifierProvider =
    StreamNotifierProvider<TodoNotifier, List<TodoDto>>(() => TodoNotifier());

class TodoNotifier extends StreamNotifier<List<TodoDto>> {
  @override
  Stream<List<TodoDto>> build() {
    final firebaseFirestore = ref.read(firebaseFirestoreProvider);
    return firebaseFirestore
        .collection('todos')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TodoDto(title: doc.data()['title'] as String))
              .toList(),
        );
  }

  // Todoを追加するメソッド
  Future<void> addTodo(String title) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.addTodo(title);
    // ストリームが自動的に更新されるので、特別な処理は不要
  }
}
