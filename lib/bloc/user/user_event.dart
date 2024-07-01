part of 'user_bloc.dart';

//In the UI we have events for create, update, delete and read users.
//We will create events for these actions in the bloc.
//We will create a sealed class UserEvent that extends Equatable.
//We will create four classes that extend UserEvent: UserCreate, UserUpdate, UserDelete, and UserRead.
//Each class will have a User object as a property.
//The User object will be passed to the constructor of the class.
//The User object will be used to create, update, delete, or read a user.
//The User object will be passed to the repository to perform the action.
//The User object will be used to update the state of the bloc.
//The User object will be used to update the UI.


sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserCreateEvent extends UserEvent {
  final UserModel user;

  const UserCreateEvent(this.user);

  @override
  List<Object> get props => [user];
}

final class UserUpdateEvent extends UserEvent {
  final UserModel user;

  const UserUpdateEvent(this.user);

  @override
  List<Object> get props => [user];
}

final class UserDeleteEvent extends UserEvent {
  final String id;

  const UserDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}


//Here to listen and load, we used separate events.
//This is because we want to listen to the stream of users and load the users from the stream.
// When fetching data from the DB sometimes the UI in Loading state
// When the UI in indeterminate state like loading
//we will use the UserRead event to listen to the stream of users.
// and quickly update the UI when the data is available.



// used to listen to stream of users
final class UserReadEvent extends UserEvent {
  
  @override
  List<Object> get props => [];
}


// Emit the list of users loaded from the stream
final class UserLoadEvent extends UserEvent {
  final List<UserModel> users;

  const UserLoadEvent(this.users);

  @override
  List<Object> get props => [users];
}


final class UserReadAllEvent extends UserEvent {
  const UserReadAllEvent();
}



