import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/logic/async_todo_notifier.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  // ここにRepositoryを追加していく。
  TodoNotifier,
  TodoRepository,
])
void main() {}
