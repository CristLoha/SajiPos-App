part of 'auth_bloc.dart';


sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}


class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}


class AuthAuthenticated extends AuthState {
  final String token;
  
  final Auth authData;

  const AuthAuthenticated({
    required this.token,
    required this.authData,
  });

  @override
  List<Object?> get props => [token, authData];
}


class AuthUnauthenticated extends AuthState {}


class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
