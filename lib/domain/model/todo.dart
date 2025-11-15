import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  const Todo({required this.title});

  final String title;

  Todo copyWith({String? title}) {
    return Todo(title: title ?? this.title);
  }

  @override
  List<Object?> get props => [title];
}
