// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/event.dart';
import 'package:to_do_list_app/Bloc/task_bloc/state.dart';
import 'package:to_do_list_app/data/dialogue.dart';
import 'package:to_do_list_app/models/to_do_model.dart';
import 'package:to_do_list_app/screens/add_task_view.dart';
import 'package:to_do_list_app/screens/single_task_detail.dart';

class TaskListScreen extends StatefulWidget {
  final int userId;

  const TaskListScreen({super.key, required this.userId});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<TaskBloc>(context).add(
      GetTasksByUserIdEvent(userId: widget.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        centerTitle: true,
        elevation: 5.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add,
                color: Color.fromARGB(255, 15, 187, 121), size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(userId: widget.userId),
                ),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskSuccessState) {
            if (state.tasks.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTaskList(state.tasks);
          } else if (state is TaskErrorState) {
            return _buildErrorState(state.message);
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
    );
  }

  Widget _buildTaskList(List<task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                task.title.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description ?? 'No Description',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  maxLines: 3, // Limit to 3 lines
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 16,
                        color: (task.status == 1 ? Colors.green : Colors.red)),
                    const SizedBox(width: 4),
                    Text(
                      task.status == 1
                          ? 'Completed'
                          : 'Incomplete', // Shows task completion status
                      style: TextStyle(
                        fontSize: 14,
                        color: task.status == 1 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final iftrue = await showConfirmationDialog(context);
                if (iftrue) {
                  context
                      .read<TaskBloc>()
                      .add(DeleteTaskEvent(taskId: task.id!));

                  // Refresh task list
                  context
                      .read<TaskBloc>()
                      .add(GetTasksByUserIdEvent(userId: widget.userId));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(microseconds: 500),
                      content: Text('Task is deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(taskDetail: task),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_outlined,
            color: Colors.blueAccent,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add a task to get started',
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
