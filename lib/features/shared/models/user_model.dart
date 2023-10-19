class UserModel {
  final String id, email, firstName, lastName;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });
}
