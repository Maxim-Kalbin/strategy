import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/contacts/bloc/contacts_bloc.dart';
import '/screens/selected/selected.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  Widget showProgress() {
    return Ink(
      color: Colors.white,
      child: const SizedBox.expand(
        child: Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ContactsBloc(),
        child: DefaultTabController(
          initialIndex: 0,
          length: 1,
          child: Scaffold(
            appBar: AppBar(
              title: const Align(
                  alignment: Alignment.centerLeft, child: Text('Home')),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ),
            body: BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context, state) {
                final bloc = BlocProvider.of<ContactsBloc>(context);
                if (state is! InitialContactsState) {
                  return TabBarView(
                    children: <Widget>[
                      ListView.builder(
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          final selected = state.selectedUsers.contains(user);
                          return ListTile(
                            tileColor:
                                selected ? Colors.lightBlue[100] : Colors.white,
                            onTap: () {
                              if (selected) {
                                bloc.add(DeselectUserEvent(deselected: user));
                              } else {
                                bloc.add(SelectUserEvent(selected: user));
                              }
                            },
                            leading: SizedBox(
                              width: 64,
                              height: 64,
                              child: Center(
                                child: Text(
                                  '${user.firstName[0]}${user.lastName[0]}',
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ),
                            ),
                            title: Text(user.firstName,
                                style: const TextStyle(fontSize: 17)),
                            subtitle: Text(user.email,
                                style: const TextStyle(fontSize: 15)),
                          );
                        },
                        itemCount: state.users.length,
                      ),
                    ],
                  );
                } else {
                  if (bloc.isNotAfter(LoadDataEvent)) {
                    bloc.add(LoadDataEvent());
                  }
                  return showProgress();
                }
              },
            ),
            floatingActionButton: BlocBuilder<ContactsBloc, ContactsState>(
                builder: (context, state) => AnimatedOpacity(
                      opacity: state.selectedUsers.isNotEmpty ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectedPage(
                                        users: state.selectedUsers,
                                      )));
                        },
                        child: const Icon(Icons.chat),
                      ),
                    )),
          ),
        ));
  }
}
