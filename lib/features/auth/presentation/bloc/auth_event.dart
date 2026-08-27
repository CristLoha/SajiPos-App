part of 'auth_bloc.dart';

// Event mewakili tindakan atau aksi dari user interface (UI)
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// 1. Event untuk memeriksa status otentikasi awal (misal saat aplikasi pertama dibuka)
class AuthCheckStatus extends AuthEvent {}

// 2. Event untuk melakukan proses Login
class AuthLoginProcess extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginProcess({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutProcess extends AuthEvent {}
