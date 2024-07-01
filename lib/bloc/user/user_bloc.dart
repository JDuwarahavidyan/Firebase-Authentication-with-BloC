import 'dart:async';

import 'package:auth/models/user_models.dart';
import 'package:auth/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  StreamSubscription <List<UserModel>>? _userStreamSubscription;
  

  // close the stream when the bloc is closed
  // to prevent memory leaks
  @override
  Future<void> close() {
    _userStreamSubscription!.cancel();
    return super.close();
  }

  UserBloc() : super(UserInitial()) {
    on<UserReadEvent>((event, emit) {
      try {
        emit(UserLoading());
        final userStreamResponse = UserService().getUsersStream();
         _userStreamSubscription?.cancel();
        _userStreamSubscription = userStreamResponse.listen((users) {
          add(UserLoadEvent(users));
        });
      } catch (e) {
        emit(const UserFailure('Failed to load users'));
      }
    });

    on<UserLoadEvent>((event, emit) {
      try {
        emit(UserLoaded(event.users));
        
      } catch (e) {
        emit(const UserFailure('Failed to load users'));
      }
    });

    on<UserCreateEvent>((event, emit) {
      try {
        if (state is UserLoaded) {
          UserService().createUser(event.user);
        }
    
      } catch (e) {
        emit(const UserFailure('Failed to create user'));
      }
    });

    on<UserUpdateEvent>((event, emit) {
       try {
        if (state is UserLoaded) {
          UserService().updateUser(event.user);
        }
    
      } catch (e) {
        emit(const UserFailure('Failed to create user'));
      }
    });

    on<UserDeleteEvent>((event, emit) {
       try {
        if (state is UserLoaded) {
          UserService().deleteUser(event.id);
        }
    
      } catch (e) {
        emit(const UserFailure('Failed to create user'));
      }
    });
  }
}
