import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_store_profile.dart';
import 'store_profile_event.dart';
import 'store_profile_state.dart';

class StoreProfileBloc extends Bloc<StoreProfileEvent, StoreProfileState> {
  final GetStoreProfile getStoreProfile;

  StoreProfileBloc({required this.getStoreProfile})
    : super(StoreProfileInitial()) {
    on<FetchStoreProfileEvent>((event, emit) async {
      emit(StoreProfileLoading());
      final result = await getStoreProfile.execute();
      result.fold(
        (failure) => emit(StoreProfileError(failure.message)),
        (storeProfile) => emit(StoreProfileLoaded(storeProfile)),
      );
    });
  }
}
