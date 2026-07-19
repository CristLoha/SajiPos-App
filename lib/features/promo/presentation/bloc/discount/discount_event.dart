part of 'discount_bloc.dart';

sealed class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object> get props => [];
}

class FetchActiveDiscounts extends DiscountEvent {}