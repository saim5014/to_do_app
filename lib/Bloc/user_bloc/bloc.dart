import 'package:bloc/bloc.dart';
import 'package:to_do_list_app/Bloc/user_bloc/event.dart';
import 'package:to_do_list_app/Bloc/user_bloc/state.dart';
import 'package:to_do_list_app/db/user_helper.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserHelper _userHelper = UserHelper(); // Instance of UserHelper

  UserBloc() : super(UserInitialState()) {
    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        await _userHelper.register(event.newUser);
        emit(UserRegistrationSuccessState());
      } catch (e) {
        emit(UserErrorState(message: e.toString()));
      }
    });

    on<UserLoginEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final loggedInUser =
            await _userHelper.login(event.username, event.password);
        emit(UserLoggedInState(loginuser: loggedInUser!));
      } on usernotfoundexception {
        emit(UserErrorState(message: 'User not found register yourself'));
      } catch (e) {
        emit(UserErrorState(message: e.toString()));
      }
    });

    on<UserUpdateEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        await _userHelper.updateUser(
            username: event.username, user: event.updatedUser);
        emit(UserUpdateSuccessState());
      } on usernotpresentexception {
        emit(UserErrorState(message: 'User not found register yourself'));
      } catch (e) {
        emit(UserErrorState(message: e.toString()));
      }
    });
    on<forgotpasswordevent>((event, emit) async {
      try {
        await _userHelper.updatepassword(event.email, event.password);
        emit(usersuccessstate());
      } on usernotfoundexception {
        emit(UserErrorState(message: 'User not found register yourself'));
      } catch (e) {
        emit(UserErrorState(message: e.toString()));
      }
    });

    on<UserDeleteEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        await _userHelper.deleteUser(event.userId);
        emit(UserDeleteSuccessState());
      } catch (e) {
        emit(UserErrorState(message: e.toString()));
      }
    });
  }
}
