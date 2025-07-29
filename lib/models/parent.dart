class ParentModel {
  final String id;
  final String username;
  final String role;
  final String email;
  final String phone;

  ParentModel({
    required this.id,
    required this.username,
    required this.role,
    required this.email,
    required this.phone,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }



  @override
  String toString() {
    return 'Parent(id: $id, username: $username, email: $email, phone: $phone)';
  }
}
