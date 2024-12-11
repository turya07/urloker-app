import 'dart:convert';
import 'package:http/http.dart' as http;

class PromoCodeService {
  Future<Map<String, dynamic>> applyPromoCode(
      String code,
      double basePrice,
      double currentTotal,
      ) async {
    final response = await http.post(
      Uri.parse('https://urlocker-api.onrender.com/api/v1/promocode/generate-bulk'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"code": code}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('API Response: $data'); // Log the response for debugging

      // Check if the code is valid and return the discount percentage
      if (data.containsKey('discountPercentage')) {
        final discountPercentage = data['discountPercentage'] ?? 0;
        final discountedPrice = basePrice - (basePrice * (discountPercentage / 100));

        return {
          'applied': true,
          'totalPrice': discountedPrice,
          'message': "Promo code applied!",
        };
      } else {
        return {
          'applied': false,
          'totalPrice': currentTotal,
          'message': "Invalid promo code!",
        };
      }
    } else {
      // Handle error if the status code is not 200
      return {
        'applied': false,
        'totalPrice': currentTotal,
        'message': "Server error or invalid promo code!",
      };
    }
  }
}
