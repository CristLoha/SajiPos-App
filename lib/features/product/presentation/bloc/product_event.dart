part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ProductEvent {
  final int? categoryId;
  final String? search;
  final bool isCategoryUpdate;
  const GetProductsEvent({
    this.categoryId,
    this.search,
    this.isCategoryUpdate = false,
  });

  @override
  List<Object> get props => [categoryId ?? -1, search ?? '', isCategoryUpdate];
}
