import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:strategy/strategy.dart';

import '/models/user_model.dart';
import '../../contacts_bloc.dart';

class LoadTasksAndUsers implements Strategy {
  const LoadTasksAndUsers();

  Future<StgContext> _(StgContext ctx) async {
    final users = <UserModel>[];

    final uri = Uri.parse('https://jsonplaceholder.typicode.com/users/');
    final http.Response response = await http.get(uri);
    final body = response.body;
    final usersJson = jsonDecode(body);

    for (var user in usersJson) {
      users.add(UserModel.fromJSON(user));
    }

    return ctx..inject('state', DataLoadedState(users: users));
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
