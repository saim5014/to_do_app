import 'package:equatable/equatable.dart';
import 'package:to_do_list_app/models/to_do_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskSuccessState extends TaskState {
  final List<task> tasks;

  const TaskSuccessState({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

class SingleTaskSuccessState extends TaskState {
  final task taskDetail;

  const SingleTaskSuccessState({required this.taskDetail});

  @override
  List<Object?> get props => [taskDetail];
}

class TaskErrorState extends TaskState {
  final String message;

  const TaskErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class TaskActionSuccessState extends TaskState {
  final String message;

  const TaskActionSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
