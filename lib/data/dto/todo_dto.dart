import 'package:equatable/equatable.dart';

class TodoDto extends Equatable {
  const TodoDto({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}
