class UserModel {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? profilePicture;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.profilePicture,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        profilePicture: json['profile_picture'] ?? 'assets/default_profile.jpg', 
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
        'profile_picture': profilePicture ?? 'assets/default_profile.jpg', 
      };
}
