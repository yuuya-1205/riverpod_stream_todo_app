import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/logic/async_todo_notifier.dart';
import 'package:flutter_riverpod_stream_todo_app/domain/model/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utils/create_container.dart';
import '../utils/mocks.mocks.dart';

void main() {
  late MockTodoNotifier mockTodoNotifier;
  setUp(() {
    mockTodoNotifier = MockTodoNotifier();
  });
  // ここのテストは？
  test('build todo notifier', () async {
    // 前提
    // 期待値

    // モックを設定する。
    // 取得してきた値がTodo(title: 'test') を確認するテスト。
    // ここが悪そう、build()が呼ばれた時にTodo(title: 'test') を返すようにしている。
    when(
      mockTodoNotifier.build(),
    ).thenAnswer((_) => Future.value([Todo(title: 'test')]));

    final container = createContainer(
      overrides: [
        asyncTodoNotifierProvider.overrideWith(() => mockTodoNotifier),
      ],
    );

    // 初期状態を確認するテスト
    final initialTodoNotifier =
        container.read(asyncTodoNotifierProvider).valueOrNull ?? [];
    expect(initialTodoNotifier, []);

    // todoを追加するテスト
    await container.read(asyncTodoNotifierProvider.notifier).addTodo('test');
    final todosAfterAdd =
        container.read(asyncTodoNotifierProvider).valueOrNull ?? [];

    // todoを追加する。
    // ここで追加しているのになぜテストが通らないのか？
    // final todos = await todoNotifier.build();
    expect(todosAfterAdd, [Todo(title: 'test')]);
  });

  test('add Todo', () async {
    // 前提 mockTodoNotifierが空のリストを返すようにしている。
    // 期待値 mockTodoNotifierが[Todo(title: 'test')]を返すようにしている。

    // stubのstateがダメって言われている。
    // そもそもstubってなんだっけ？
    // stubはモックのメソッドを呼び出した時に、そのメソッドが呼び出されたことを確認するためのもの。
    when(mockTodoNotifier.addTodo('test')).thenAnswer((_) => Future.value());

    await mockTodoNotifier.addTodo('test');
    expect(mockTodoNotifier.state.value, [Todo(title: 'test')]);
  });
}
