import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class PostLogin {
  final AuthRepository repository;

  PostLogin(this.repository);

  Future<Either<Failure, Auth>> execute({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
