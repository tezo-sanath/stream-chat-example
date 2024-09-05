class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});
}

List<UserModel> usersList = [
  UserModel(id: "1", name: "User - 1", email: "user1@email.com"),
  UserModel(id: "2", name: "User - 2", email: "user2@email.com"),
  UserModel(id: "3", name: "User - 3", email: "user3@email.com"),
  UserModel(id: "4", name: "User - 4", email: "user4@email.com"),
  UserModel(id: "5", name: "User - 5", email: "user5@email.com"),
  UserModel(id: "6", name: "User - 6", email: "user6@email.com"),
];
