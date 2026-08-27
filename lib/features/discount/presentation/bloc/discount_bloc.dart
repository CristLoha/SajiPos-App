import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/discount/domain/entities/discount.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/get_active_discount.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/get_unseen_discount_count.dart';
import 'package:saji_pos_app/features/discount/domain/usecases/mark_discounts_as_seen.dart';
part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final GetActiveDiscount getActiveDiscount;
  final GetUnseenDiscountCount getUnseenDiscountCount;
  final MarkDiscountsAsSeen markDiscountsAsSeen;

  DiscountBloc({
    required this.getActiveDiscount,
    required this.getUnseenDiscountCount,
    required this.markDiscountsAsSeen,
  }) : super(DiscountInitial()) {
    on<FetchActiveDiscounts>((event, emit) async {
      emit(DiscountLoading());

      final result = await getActiveDiscount(
        search: event.search,
        status: event.status,
      );

      final unseenResult = await getUnseenDiscountCount();
      int unseenCount = 0;
      unseenResult.fold((l) => null, (count) => unseenCount = count);

      result.fold((failure) => emit(DiscountError(failure.message)), (data) {
        if (data.isEmpty) {
          emit(DiscountEmpty());
        } else {
          emit(DiscountLoaded(data, unseenCount: unseenCount));
        }
      });
    });

    on<MarkDiscountsAsSeenEvent>((event, emit) async {
      if (state is DiscountLoaded) {
        final currentState = state as DiscountLoaded;
        await markDiscountsAsSeen();
        emit(DiscountLoaded(currentState.discounts, unseenCount: 0));
      }
    });
  }
}
