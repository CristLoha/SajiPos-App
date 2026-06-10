import 'package:equatable/equatable.dart';
import 'user.dart';

class Auth extends Equatable {
  const Auth({
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
