import 'package:equatable/equatable.dart';
import 'user_model.dart';
import 'package:saji_pos_app/features/auth/domain/entities/auth.dart';

class AuthModel extends Equatable {
  const AuthModel({
    required this.user,
    required this.token,
  });

  final UserModel user;
  final String token;

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapping under "data" if present
    final data = json['data'] != null ? json['data'] as Map<String, dynamic> : json;
    return AuthModel(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  Auth toEntity() {
    return Auth(
      user: user.toEntity(),
      token: token,
    );
  }

  @override
  List<Object?> get props => [user, token];
}
