import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/product/domain/entities/product.dart';
import 'package:saji_pos_app/features/product/domain/usecases/get_product.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProduct getProduct;

  ProductBloc(this.getProduct) : super(ProductInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());

      final result = await getProduct.execute(categoryId: event.categoryId);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (data) => emit(ProductLoaded(data)),
      );
    });
  }
}
