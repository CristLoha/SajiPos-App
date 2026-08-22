import 'package:equatable/equatable.dart';

sealed class StoreProfileEvent extends Equatable {
  const StoreProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchStoreProfileEvent extends StoreProfileEvent {}
