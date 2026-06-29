part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class SubmitOrderEvent extends OrderEvent {
  final OrderRequest request;

  const SubmitOrderEvent(this.request);

  @override
  List<Object> get props => [request];
}

class CheckOrderStatusEvent extends OrderEvent {
  final int orderId;
  const CheckOrderStatusEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}
