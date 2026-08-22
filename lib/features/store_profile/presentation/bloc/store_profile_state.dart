import 'package:equatable/equatable.dart';
import '../../domain/entities/store_profile.dart';

sealed class StoreProfileState extends Equatable {
  const StoreProfileState();

  @override
  List<Object?> get props => [];
}

class StoreProfileInitial extends StoreProfileState {}

class StoreProfileLoading extends StoreProfileState {}

class StoreProfileLoaded extends StoreProfileState {
  final StoreProfile storeProfile;

  const StoreProfileLoaded(this.storeProfile);

  @override
  List<Object?> get props => [storeProfile];
}

class StoreProfileError extends StoreProfileState {
  final String message;

  const StoreProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
