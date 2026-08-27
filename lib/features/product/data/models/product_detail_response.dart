import 'package:equatable/equatable.dart';
import 'product_detail_model.dart';

class ProductDetailResponse extends Equatable {
  final bool success;
  final String message;
  final ProductDetailModel data;

  const ProductDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProductDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  List<Object?> get props => [success, message, data];
}
