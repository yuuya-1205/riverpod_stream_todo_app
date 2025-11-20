import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/data/dto/todo_dto.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/logic/async_todo_notifier.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/model/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utils/create_container.dart';
import '../utils/mocks.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });
  test('build() は Repository からデータを取得し、TodoDto を Todo に変換する', () async {
    // Repository の fetchTodos() が返す Stream をモックする。
    // これが前提かな？
    when(
      mockTodoRepository.fetchTodos(),
    ).thenAnswer((_) => Stream.value([TodoDto(title: 'test')]));

    // Repository をモックに置き換えた Container を作成する。
    final container = createContainer(
      overrides: [
        todoRepositoryProvider.overrideWith((_) => mockTodoRepository),
      ],
    );

    // Notifier の build() を実行する（実際の Notifier を使用）。
    final notifier = container.read(asyncTodoNotifierProvider.notifier);
    await notifier.future;

    // 状態が正しく変換されているか確認する。
    final state = container.read(asyncTodoNotifierProvider);
    expect(state.value, [Todo(title: 'test')]);

    // Repository の fetchTodos() が呼ばれたことを確認する。
    verify(mockTodoRepository.fetchTodos()).called(1);
  });

  test('addTodo', () async {
    when(
      mockTodoRepository.fetchTodos(),
    ).thenAnswer((_) => Stream.value([TodoDto(title: 'test')]));

    // Repository をモックに置き換えた Container を作成する。
    final container = createContainer(
      overrides: [
        todoRepositoryProvider.overrideWith((_) => mockTodoRepository),
      ],
    );

    // Notifier の build() を実行する（実際の Notifier を使用）。
    final notifier = container.read(asyncTodoNotifierProvider.notifier);
    await notifier.future;

    // 状態が正しく変換されているか確認する。
    final state = container.read(asyncTodoNotifierProvider);
    expect(state.value, [Todo(title: 'test')]);

    // addTodoを呼び出して、TodoDto(title: 'test2')を追加する。
    notifier.addTodo('test2');

    when(
      mockTodoRepository.fetchTodos(),
    ).thenAnswer((_) => Stream.value([TodoDto(title: 'test2')]));

    // fetchTodosを呼び出して、TodoDto(title: 'test2')が追加されていることを確認する。
    final todos = await mockTodoRepository.fetchTodos().first;
    expect(todos, [TodoDto(title: 'test2')]);
  });
}
