import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/event.dart';
import 'package:to_do_list_app/Bloc/task_bloc/state.dart';

import 'package:to_do_list_app/db/task_helper.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskHelper _taskHelper = TaskHelper();

  TaskBloc() : super(TaskInitialState()) {
    // Handling each event using on<Event, Emit> approach

    // Create Task
    on<CreateTaskEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        await _taskHelper.createTask(event.newTask);
        emit(
            const TaskActionSuccessState(message: 'Task created successfully'));
      } catch (e) {
        emit(TaskErrorState(message: e.toString()));
      }
    });

    // Get All Tasks by User ID
    on<GetTasksByUserIdEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        var tasks = await _taskHelper.getTasksByUserId(event.userId);
        emit(TaskSuccessState(tasks: tasks));
      } on notaskisfoundbyid {
        emit(const TaskErrorState(message: 'no task is present for this user'));
      } catch (e) {
        emit(TaskErrorState(message: e.toString()));
      }
    });

    // Get Task by Task ID
    on<GetTaskByIdEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        var taskDetail = await _taskHelper.getTaskById(event.taskId);
        if (taskDetail != null) {
          emit(SingleTaskSuccessState(taskDetail: taskDetail));
        } else {
          emit(const TaskErrorState(message: 'Task not found'));
        }
      } catch (e) {
        emit(TaskErrorState(message: e.toString()));
      }
    });

    // Update Task
    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        await _taskHelper.updateTask(event.updatedTask);
        emit(
            const TaskActionSuccessState(message: 'Task updated successfully'));
      } catch (e) {
        emit(TaskErrorState(message: e.toString()));
      }
    });

    // Delete Task
    on<DeleteTaskEvent>((event, emit) async {
      try {
        await _taskHelper.deleteTask(event.taskId);
      } catch (e) {
        emit(TaskErrorState(message: e.toString()));
      }
    });
  }
}
