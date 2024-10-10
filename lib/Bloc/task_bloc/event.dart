import 'package:equatable/equatable.dart';
import 'package:to_do_list_app/models/to_do_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  final task newTask;

  const CreateTaskEvent({required this.newTask});

  @override
  List<Object?> get props => [newTask];
}

class GetTasksByUserIdEvent extends TaskEvent {
  final int userId;

  const GetTasksByUserIdEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetTaskByIdEvent extends TaskEvent {
  final int taskId;

  const GetTaskByIdEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskEvent extends TaskEvent {
  final task updatedTask;

  const UpdateTaskEvent({required this.updatedTask});

  @override
  List<Object?> get props => [updatedTask];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
