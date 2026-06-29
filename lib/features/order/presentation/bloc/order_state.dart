part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderSuccess extends OrderState {
  final Order order;
  const OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);
  @override
  List<Object> get props => [message];
}

final class OrderStatusChecked extends OrderState {
  final Order order;
  const OrderStatusChecked(this.order);

  @override
  List<Object> get props => [order];
}
