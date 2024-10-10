// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';
import 'package:to_do_list_app/models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoggedInState extends UserState {
  final user loginuser; // User object for logged in state

  UserLoggedInState({required this.loginuser});

  @override
  List<Object?> get props => [loginuser];
}

class UserRegistrationSuccessState extends UserState {}

class UserFetchSuccessState extends UserState {
  final List<user> users;

  UserFetchSuccessState({required this.users});

  @override
  List<Object?> get props => [users];
}

class usersuccessstate extends UserState {}

class UserUpdateSuccessState extends UserState {
  UserUpdateSuccessState();

  @override
  List<Object?> get props => [];
}

class UserDeleteSuccessState extends UserState {}

class UserErrorState extends UserState {
  final String message;

  UserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class forgotpasswordstate extends UserState {
  final String password;

  forgotpasswordstate({required this.password});
  @override
  List<Object?> get props => [password];
}
