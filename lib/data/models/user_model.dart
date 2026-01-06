import 'package:equatable/equatable.dart';

class RoleModel extends Equatable {
  final String id;
  final String name;

  const RoleModel({
    required this.id,
    required this.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? token;
  final RoleModel? role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      token: json['token'],
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'role': role?.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    RoleModel? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, email, name, token, role];
}
