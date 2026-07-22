import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/get_active_discount.dart';
part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final GetActiveDiscount getActiveDiscount;
  DiscountBloc({required this.getActiveDiscount}) : super(DiscountInitial()) {
    on<FetchActiveDiscounts>((event, emit) async {
      emit(DiscountLoading());

      final result = await getActiveDiscount(
        search: event.search,
        status: event.status,
      );

      result.fold((failure) => emit(DiscountError(failure.message)), (data) {
        if (data.isEmpty) {
          emit(DiscountEmpty());
        } else {
          emit(DiscountLoaded(data));
        }
      });
    });
  }
}
