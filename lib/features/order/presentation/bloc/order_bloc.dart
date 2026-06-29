import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/order/domain/entities/order_request.dart';
import 'package:saji_pos_app/features/order/domain/entities/order.dart';
import 'package:saji_pos_app/features/order/domain/usecases/submit_order.dart';
import 'package:saji_pos_app/features/order/domain/usecases/get_order_status.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final SubmitOrder submitOrder;
  final GetOrderStatus getOrderStatus;

  OrderBloc({
    required this.submitOrder,
    required this.getOrderStatus,
  }) : super(OrderInitial()) {
    on<SubmitOrderEvent>((event, emit) async {
      emit(OrderLoading());

      final result = await submitOrder(event.request);

      result.fold(
        (failure) => emit(OrderError(failure.message)),
        (success) => emit(OrderSuccess(success)),
      );
    });

    on<CheckOrderStatusEvent>((event, emit) async {
      emit(OrderLoading());
      final result = await getOrderStatus(event.orderId);
      result.fold(
        (failure) => emit(OrderError(failure.message)),
        (success) => emit(OrderStatusChecked(success)),
      );
    });
  }
}
