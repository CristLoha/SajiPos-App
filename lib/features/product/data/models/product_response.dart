import 'package:equatable/equatable.dart';
import 'product_model.dart';

class ProductResponse extends Equatable {
  final List<ProductModel> productList;

  const ProductResponse({required this.productList});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productList: List<ProductModel>.from(
        (json["data"] as List).map(
          (x) => ProductModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": List<dynamic>.from(productList.map((x) => x.toJson())),
    };
  }

  @override
  List<Object> get props => [productList];
}
