class User {
  final String name, email, role, id;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      email: json["email"],
      id: json["_id"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}
