import 'package:equatable/equatable.dart';
import '../../domain/entities/store_profile.dart';

class StoreProfileModel extends Equatable {
  final String name;
  final String address;
  final String phone;
  final String? logoUrl;
  final bool showPhoneOnReceipt;
  final bool showAddressOnReceipt;
  final bool showLogoOnReceipt;

  const StoreProfileModel({
    required this.name,
    required this.address,
    required this.phone,
    this.logoUrl,
    required this.showPhoneOnReceipt,
    required this.showAddressOnReceipt,
    required this.showLogoOnReceipt,
  });

  factory StoreProfileModel.fromJson(Map<String, dynamic> json) {
    return StoreProfileModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      logoUrl: json['logo_url'],
      showPhoneOnReceipt: json['show_phone_on_receipt'] ?? false,
      showAddressOnReceipt: json['show_address_on_receipt'] ?? false,
      showLogoOnReceipt: json['show_logo_on_receipt'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'logo_url': logoUrl,
      'show_phone_on_receipt': showPhoneOnReceipt,
      'show_address_on_receipt': showAddressOnReceipt,
      'show_logo_on_receipt': showLogoOnReceipt,
    };
  }

  StoreProfile toEntity() {
    return StoreProfile(
      name: name,
      address: address,
      phone: phone,
      logoUrl: logoUrl,
      showPhoneOnReceipt: showPhoneOnReceipt,
      showAddressOnReceipt: showAddressOnReceipt,
      showLogoOnReceipt: showLogoOnReceipt,
    );
  }

  @override
  List<Object?> get props => [
        name,
        address,
        phone,
        logoUrl,
        showPhoneOnReceipt,
        showAddressOnReceipt,
        showLogoOnReceipt,
      ];
}
