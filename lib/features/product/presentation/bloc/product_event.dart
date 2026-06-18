part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ProductEvent {
  final int? categoryId;
  const GetProductsEvent({this.categoryId});

  @override
  List<Object> get props => [categoryId ?? -1];
}
