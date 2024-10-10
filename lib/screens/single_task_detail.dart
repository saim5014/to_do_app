// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/event.dart';
import 'package:to_do_list_app/db/task_helper.dart';
import 'package:to_do_list_app/models/to_do_model.dart';

import 'package:to_do_list_app/screens/update_task.dart';

class TaskDetailScreen extends StatefulWidget {
  final task taskDetail;

  const TaskDetailScreen({super.key, required this.taskDetail});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late task _task;
  final TaskHelper _taskHelper = TaskHelper(); // For DB operations

  @override
  void initState() {
    super.initState();
    _task = widget.taskDetail; // Initialize the task from the passed argument
  }

  Future<void> _toggleTaskStatus() async {
    setState(() {
      // Toggle the task status
      _task.status = _task.status == 1 ? 0 : 1;
    });

    // Update the task status in the database
    await _taskHelper.updateTask(_task);
    context
        .read<TaskBloc>()
        .add(GetTasksByUserIdEvent(userId: widget.taskDetail.userid));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_task.status == 1
            ? 'Task marked as complete'
            : 'Task marked as incomplete'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        elevation: 5.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateTaskScreen(taskDetail: widget.taskDetail),
                ),
              );
              // Navigate to edit task screen (if implemented)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Task Title
            Text(
              _task.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Task Description with better visual structure
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                _task.description ?? 'No description provided',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Due Date
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  'Due Date: ${_task.date}',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task Status
            Row(
              children: [
                Icon(
                  _task.status == 1
                      ? Icons.check_circle_outline
                      : Icons.remove_circle_outline,
                  color: _task.status == 1 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _task.status == 1 ? 'Status: Complete' : 'Status: Incomplete',
                  style: TextStyle(
                    fontSize: 18,
                    color: _task.status == 1 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Toggle Status Button with lavish style
            Center(
              child: ElevatedButton(
                onPressed:
                    _toggleTaskStatus, // Call the function to toggle the status
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  backgroundColor:
                      _task.status == 1 ? Colors.redAccent : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _task.status == 1 ? 'Mark as Incomplete' : 'Mark as Complete',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
