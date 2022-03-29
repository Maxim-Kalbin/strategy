import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:strategy/strategy.dart';

import '/models/user_model.dart';
import '/screens/contacts/bloc/strategies/initialization/load_users.dart';
import '/screens/contacts/bloc/strategies/selection/deselect_user.dart';
import '/screens/contacts/bloc/strategies/selection/select_user.dart';

part 'components/contacts_event.dart';
part 'components/contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState>
    with StrategyMixin<ContactsEvent> {
  ContactsBloc() : super(InitialContactsState()) {
    on<ContactsEvent>((event, emit) async {
      final ctx = await invoke(event);
      emit(ctx.find<ContactsState>('state'));
    });
  }

  @override
  final Map<Type, Strategy> strategies = const <Type, Strategy>{
    LoadDataEvent: LoadTasksAndUsers(),
    SelectUserEvent: SelectUser(),
    DeselectUserEvent: DeselectUser(),
  };
}
