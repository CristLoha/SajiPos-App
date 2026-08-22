import 'package:dartz/dartz.dart';
import 'package:saji_pos_app/core/error/failures.dart';
import '../entities/store_profile.dart';

abstract class StoreProfileRepository {
  Future<Either<Failure, StoreProfile>> getStoreProfile();
}
