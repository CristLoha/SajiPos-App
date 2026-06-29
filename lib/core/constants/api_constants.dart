class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  // static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String logoutEndpoint = '$baseUrl/logout';

  static const String productsEndpoint = '$baseUrl/products';

  static const String categoriesEndpoint = '$baseUrl/categories';

  static const String discountsEndpoint = '$baseUrl/discounts';

  static const String ordersEndpoint = '$baseUrl/orders';
}
