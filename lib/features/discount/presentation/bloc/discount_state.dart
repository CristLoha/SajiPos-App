part of 'discount_bloc.dart';

sealed class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object> get props => [];
}

final class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountLoaded extends DiscountState {
  final List<Discount> discounts;
  final int unseenCount;

  const DiscountLoaded(this.discounts, {this.unseenCount = 0});

  @override
  List<Object> get props => [discounts, unseenCount];
}

class DiscountError extends DiscountState {
  final String message;

  const DiscountError(this.message);

  @override
  List<Object> get props => [message];
}

class DiscountEmpty extends DiscountState {}
