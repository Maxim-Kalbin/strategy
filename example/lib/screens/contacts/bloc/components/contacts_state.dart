part of '../contacts_bloc.dart';

@immutable
abstract class ContactsState {
  List<UserModel> get users;

  List<UserModel> get selectedUsers;
}

class InitialContactsState extends ContactsState {
  @override
  List<UserModel> get users => const [];

  @override
  List<UserModel> get selectedUsers => const [];
}

class DataLoadedState extends ContactsState {
  DataLoadedState({
    required this.users,
  });

  @override
  final List<UserModel> users;
  @override
  List<UserModel> get selectedUsers => const [];
}

class UsersSelectedState extends ContactsState {
  UsersSelectedState({required this.users, required this.selectedUsers});

  @override
  final List<UserModel> users;
  @override
  final List<UserModel> selectedUsers;
}

class UsersDeselectedState extends ContactsState {
  UsersDeselectedState({required this.users, required this.selectedUsers});

  @override
  final List<UserModel> users;
  @override
  final List<UserModel> selectedUsers;
}
