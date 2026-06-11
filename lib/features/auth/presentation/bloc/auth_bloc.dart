import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/auth/domain/entities/auth.dart';
import 'package:saji_pos_app/features/auth/domain/entities/user.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/get_token.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_login.dart';
import 'package:saji_pos_app/features/auth/domain/usecases/post_logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetToken getToken;
  final PostLogin postLogin;
  final PostLogout postLogout;

  AuthBloc({
    required this.getToken,
    required this.postLogin,
    required this.postLogout,
  }) : super(AuthInitial()) {
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthLoginProcess>(_onAuthLoginProcess);
    on<AuthLogoutProcess>(_onAuthLogoutProcess);
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getToken.execute();

    result.fold((failure) => emit(AuthUnauthenticated()), (token) {
      if (token != null && token.isNotEmpty) {
        emit(
          AuthAuthenticated(
            token: token,
            authData: Auth(
              token: token,
              user: const User(
                id: 0,
                name: 'Kasir',
                email: '',
                createdAt: '',
                updatedAt: '',
              ),
            ),
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthLoginProcess(
    AuthLoginProcess event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await postLogin.execute(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (authData) {
        emit(AuthAuthenticated(token: authData.token, authData: authData));
      },
    );
  }

  Future<void> _onAuthLogoutProcess(
    AuthLogoutProcess event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await postLogout.execute();

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
