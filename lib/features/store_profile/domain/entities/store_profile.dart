import 'package:equatable/equatable.dart';

class StoreProfile extends Equatable {
  final String name;
  final String address;
  final String phone;
  final String? logoUrl;
  final bool showPhoneOnReceipt;
  final bool showAddressOnReceipt;
  final bool showLogoOnReceipt;

  const StoreProfile({
    required this.name,
    required this.address,
    required this.phone,
    this.logoUrl,
    required this.showPhoneOnReceipt,
    required this.showAddressOnReceipt,
    required this.showLogoOnReceipt,
  });

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
