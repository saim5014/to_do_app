// ignore_for_file: camel_case_types

import 'package:to_do_list_app/db/helper_db.dart';
import 'package:to_do_list_app/models/user_model.dart';

class usernotfoundexception implements Exception {}

class nouserexception implements Exception {}

class usernotpresentexception implements Exception {}

class UserHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Create a new user
  Future<int> register(user user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.tomap());
  }

  // Get a user by username (for login)
  Future<user?> login(String username, String password) async {
    final db = await _dbHelper.database;
    var result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return user.frommap(result.first);
    } else {
      throw usernotfoundexception();
    }
  }

  // Get all users
  Future<List<user>> getAllUsers() async {
    final db = await _dbHelper.database;
    var result = await db.query('users');
    return result.isNotEmpty
        ? result.map((u) => user.frommap(u)).toList()
        : throw nouserexception();
  }

  // Update a user's info
  Future<int> updateUser({required String username, required user user}) async {
    final db = await _dbHelper.database;
    final res = await db.query('users',
        where: 'username = ?', whereArgs: [username], limit: 1);

    if (res.isNotEmpty) {
      return await db.update(
        'users',
        user.tomap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } else {
      throw usernotpresentexception();
    }
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    final db = await _dbHelper.database;

    final result = await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == 0) {
      throw usernotfoundexception();
    }
  }

  //delete a usser by the email,
  Future<void> deleteUserbyemail({required String email}) async {
    final db = await _dbHelper.database;

    final result = await db.delete(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result == 0) {
      throw usernotfoundexception();
    }
  }

  Future<void> updatepassword(String email, String password) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      'users',
      where: 'email= ?',
      whereArgs: [email],
      limit: 1,
    );
    if (res.isEmpty) {
      throw usernotfoundexception();
    } else {
      await db.update('users', {'password': password},
          where: 'email = ?', whereArgs: [email]);
    }
  }
}
