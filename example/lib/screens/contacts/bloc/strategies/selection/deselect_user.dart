import 'package:strategy/strategy.dart';

import '../../contacts_bloc.dart';

class DeselectUser implements Strategy {
  const DeselectUser();
  Future<StgContext> _(StgContext ctx) async {
    final user = ctx.find<DeselectUserEvent>('event').deselected;
    final prevState = ctx.find<ContactsState>('state');
    final prevSelected = [...prevState.selectedUsers];
    final newState = UsersDeselectedState(
        users: prevState.users, selectedUsers: prevSelected..remove(user));

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
