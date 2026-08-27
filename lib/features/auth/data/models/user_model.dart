import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/auth/domain/entities/user.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      // Mengamankan casting null/String jika data created_at dan updated_at bernilai null dari API
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  ];
}
