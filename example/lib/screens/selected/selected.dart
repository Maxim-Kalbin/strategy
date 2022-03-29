import 'package:flutter/material.dart';

import '/models/user_model.dart';

class SelectedPage extends StatelessWidget {
  SelectedPage({required this.users});
  final List<UserModel> users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Selected (${users.length})')),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: SizedBox(
              width: 64,
              height: 64,
              child: Center(
                child: Text(
                  '${user.firstName[0]}${user.lastName[0]}',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            title: Text(user.firstName, style: TextStyle(fontSize: 17)),
            subtitle: Text(user.email, style: TextStyle(fontSize: 15)),
          );
        },
        itemCount: users.length,
      ),
    );
  }
}
