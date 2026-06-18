import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/category/domain/entities/category.dart';
import 'package:saji_pos_app/features/category/domain/usecases/get_categories.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  CategoryBloc(this.getCategories) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      final result = await getCategories.execute();

      result.fold(
        (failure) => emit(CategoryError(failure.message)),
        (data) => emit(CategoryLoaded(data)),
      );
    });
  }
}
