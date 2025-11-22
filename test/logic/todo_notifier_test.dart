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
  });

  test('addTodo', () async {
    // 前提 : Firebaseから取得した値がTodoDto(title: 'test')から
    // Todo(title: 'test')に変換されていることを確認できていること。

    // 期待値 : addTodoを呼び出して、TodoDto(title: 'test2')を追加すると、
    // [Todo(title: 'test'), Todo(title: 'test2')] が取得できていることが確認できる。

    // mockTodoRepositoryのfetchTodosで取得してきたものが
    // TodoDto(title: 'test')であることを確認する。
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

    // List<Todo>を取得する。
    final listTodo = await notifier.future;

    // List<Todo>に変換されていることを確認する。
    // ここまででRepositoryから取得したList<TodoDto>がList<Todo>に変換されていることを確認できた。
    expect(listTodo, [Todo(title: 'test')]);

    // 状態が正しく変換されているか確認する。
    // ここではbuilderの値を取得している。
    // stateの更新が行われているか確認すること。
    // Repositoryからfetchしてbuilderで更新する。そのため、fetchしてきたらbuilderの更新を行なっていることが証明できる。
    final state = container.read(asyncTodoNotifierProvider);
    expect(state.value, [Todo(title: 'test')]);

    // addTodoを呼び出して、TodoDto(title: 'test2')を追加する。
    await notifier.addTodo('test2');

    // 追加した後にstateを再取得する。
    final updateListTodo = container.read(asyncTodoNotifierProvider).value;

    // 追加した後のstateが正しく更新されているか確認する。
    expect(updateListTodo, <Todo>[Todo(title: 'test'), Todo(title: 'test2')]);
  });
}
