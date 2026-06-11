import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';


class PostLogout {
  final AuthRepository repository;

  PostLogout(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.logout();
  }
}
