// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';
import 'package:to_do_list_app/models/user_model.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserRegisterEvent extends UserEvent {
  final user newUser;

  UserRegisterEvent({required this.newUser});

  @override
  List<Object?> get props => [newUser];
}

class UserLoginEvent extends UserEvent {
  final String username;
  final String password;

  UserLoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class UserFetchEvent extends UserEvent {}

class UserUpdateEvent extends UserEvent {
  final String username;

  final user updatedUser;

  UserUpdateEvent({
    required this.updatedUser,
    required this.username,
  });

  @override
  List<Object?> get props => [updatedUser];
}

class forgotpasswordevent extends UserEvent {
  final String email;
  final String password;

  forgotpasswordevent({
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [email];
}

class UserDeleteEvent extends UserEvent {
  final int userId;

  UserDeleteEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
