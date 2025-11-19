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
  test('addTodo', () async {
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
}
