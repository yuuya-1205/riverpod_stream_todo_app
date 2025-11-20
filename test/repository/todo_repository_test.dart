import 'package:flutter_riverpod_stream_todo_app/data/dto/todo_dto.dart';
import 'package:flutter_riverpod_stream_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../utils/create_container.dart';
import '../utils/mocks.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });
  test('fetchTodos', () async {
    // 前提 : Firebaseから取得した値がTodoDto(title: 'test') を確認するテスト。
    // 期待値 : [TodoDto(title: 'test')] が取得できていることが確認できる。。

    // モックを設定する。
    // ここは今回のテストの答え（こうなるよ！）ってことを記載する。
    when(
      mockTodoRepository.fetchTodos(),
    ).thenAnswer((_) => Stream.value([TodoDto(title: 'test')]));

    // todoRepositoryProviderをmockTodoRepositoryに変更する。
    final container = createContainer(
      overrides: [
        todoRepositoryProvider.overrideWith((_) => mockTodoRepository),
      ],
    );
    final todoRepository = container.read(todoRepositoryProvider);
    final todos = await todoRepository.fetchTodos().first;
    expect(todos, [TodoDto(title: 'test')]);
  });

  test('addTodo', () async {
    // 前提 : Todoを追加するメソッドが呼ばれたことを確認するテスト。
    // 期待値 : Todoが追加されたことが確認できる。。

    // モックを設定する。
    // Streamで初期は空のリストを返すようにする。（前提は何もない状態）
    // ここは今回のテストの正解を記載するところ。
    // 今回の正解はadd関数を使ってTodoDto(title: 'test')を追加した時に、
    //　　fetchTodosでTodoDto(title: 'test')が取得できるようにする。
    when(
      mockTodoRepository.fetchTodos(),
    ).thenAnswer((_) => Stream.value([TodoDto(title: 'test')]));

    // add関数を用いてTodoDto(title: 'test')を追加する。
    await mockTodoRepository.addTodo('test');

    // ここでfetchTodosを呼び出して、TodoDto(title: 'test')が追加されていることを確認する。
    final todos = await mockTodoRepository.fetchTodos().first;

    // ここでfetchTodosでTodoDto(title: 'test')が取得できることを確認する。
    expect(todos, [TodoDto(title: 'test')]);
  });
}
