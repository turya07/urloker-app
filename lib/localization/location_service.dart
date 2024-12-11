import 'dart:convert';
import 'package:http/http.dart' as http;


class LocationService {
  static const String apiUrl = 'https://urlocker-api.onrender.com/api/v1/locations/public/all-locations';

  Future<List<dynamic>> fetchLocations() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load locations');
    }
  }
}


//===========//


