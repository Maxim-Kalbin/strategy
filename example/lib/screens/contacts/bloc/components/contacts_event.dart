part of '../contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}

class LoadDataEvent implements ContactsEvent {}

class SelectUserEvent implements ContactsEvent {
  SelectUserEvent({required this.selected});

  final UserModel selected;
}

class DeselectUserEvent implements ContactsEvent {
  DeselectUserEvent({required this.deselected});

  final UserModel deselected;
}
