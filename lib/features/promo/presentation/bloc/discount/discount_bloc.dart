import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/promo/domain/entities/discount.dart';
import 'package:saji_pos_app/features/promo/domain/usecases/get_active_discount.dart';
part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final GetActiveDiscount getActiveDiscount;
  DiscountBloc(this.getActiveDiscount) : super(DiscountInitial()) {
    on<DiscountEvent>((event, emit) async {
      emit(DiscountLoading());
      final result = await getActiveDiscount();

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
