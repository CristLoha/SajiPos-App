import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/store_profile.dart';
import '../repositories/store_profile_repository.dart';

class GetStoreProfile {
  final StoreProfileRepository repository;

  GetStoreProfile(this.repository);

  Future<Either<Failure, StoreProfile>> execute() {
    return repository.getStoreProfile();
  }
}
