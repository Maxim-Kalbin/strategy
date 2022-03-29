class UserModel {
  UserModel.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'] {
    final list = json['name'].split(' ');
    if (list.first.contains('Mrs.')) {
      firstName = list[1];
      lastName = list.last;
    } else {
      firstName = list.first;
      lastName = list[1];
    }
  }
  final int id;
  late final String firstName;
  late final String lastName;
  final String email;

  @override
  bool operator ==(Object other) {
    if (other is! UserModel) {
      return false;
    } else {
      return id == other.id;
    }
  }
}
