import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/bloc.dart';
import 'package:to_do_list_app/Bloc/task_bloc/event.dart';
import 'package:to_do_list_app/models/to_do_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final task taskDetail;

  const UpdateTaskScreen({super.key, required this.taskDetail});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskDetail.title);
    _descriptionController =
        TextEditingController(text: widget.taskDetail.description ?? '');
    _selectedDate = DateTime.tryParse(widget.taskDetail.date);
    _isCompleted = widget.taskDetail.status == 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Task Description'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(_selectedDate == null
                      ? 'Pick Due Date'
                      : 'Selected Date: ${_selectedDate!.toLocal()}'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Task Completed: '),
                    Checkbox(
                      value: _isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          _isCompleted = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a due date')),
                        );
                      } else {
                        _updateTask(context);
                      }
                    }
                  },
                  child: const Text('Update Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateTask(BuildContext context) {
    try {
      BlocProvider.of<TaskBloc>(context).add(
        UpdateTaskEvent(
          updatedTask: task(
            id: widget.taskDetail.id,
            userid: widget.taskDetail.userid,
            title: _titleController.text,
            description: _descriptionController.text,
            date: _selectedDate.toString(),
            status: _isCompleted ? 1 : 0,
          ),
        ),
      );
      context
          .read<TaskBloc>()
          .add(GetTasksByUserIdEvent(userId: widget.taskDetail.userid));
      Navigator.pop(context); // Go back after updating the task
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }
}
