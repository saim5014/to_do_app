// ignore_for_file: camel_case_types

import 'package:to_do_list_app/db/helper_db.dart';
import 'package:to_do_list_app/models/to_do_model.dart';

class notaskisfound implements Exception {}

class notaskisfoundbyid implements Exception {}

class TaskHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Create a new task
  Future<int> createTask(task task) async {
    final db = await _dbHelper.database;
    return await db.insert('tasks', task.tomap());
  }

  // Get all tasks for a specific user
  Future<List<task>> getTasksByUserId(int userId) async {
    final db = await _dbHelper.database;
    var result = await db.query(
      'tasks',
      where: 'userid = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty
        ? result.map((t) => task.frommap(t)).toList()
        : throw notaskisfoundbyid();
  }

  // Get a task by ID
  Future<task?> getTaskById(int taskId) async {
    final db = await _dbHelper.database;
    var result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    if (result.isNotEmpty) {
      return task.frommap(result.first);
    }
    throw notaskisfound();
  }

  // Update a task
  Future<int> updateTask(task task) async {
    final db = await _dbHelper.database;
    return await db.update(
      'tasks',
      task.tomap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(int taskId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
