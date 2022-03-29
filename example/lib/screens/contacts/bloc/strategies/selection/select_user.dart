import 'package:strategy/strategy.dart';

import '../../contacts_bloc.dart';

class SelectUser implements Strategy {
  const SelectUser();
  Future<StgContext> _(StgContext ctx) async {
    final user = ctx.find<SelectUserEvent>('event').selected;
    final prevState = ctx.find<ContactsState>('state');
    final prevSelected = [...prevState.selectedUsers];
    final newState = UsersSelectedState(
        users: prevState.users, selectedUsers: prevSelected..add(user));

    return Future.value(ctx..inject('state', newState));
  }

  @override
  Future<StgContext> call(StgContext ctx) async {
    if (!ctx.expired) {
      return await _(ctx);
    } else {
      throw Exception(
          '[$runtimeType Error] Tried to invoke the strategy after timeout, please handle this case');
    }
  }
}
