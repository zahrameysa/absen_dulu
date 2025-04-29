import 'dart:convert';
import 'package:absen_dulu/services/pref_handler.dart';
import 'package:http/http.dart' as http;

class CheckOutService {
  final String baseUrl = 'http://absen.quidi.id/api'; // Ganti kalau nanti perlu

  Future<Map<String, dynamic>> checkOut({
    required double lat,
    required double lng,
    required String address,
  }) async {
    final String token = await PreferenceHandler.getToken();

    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final url = Uri.parse('$baseUrl/absen/check-out');

    final body = {
      'check_out_lat': lat.toString(),
      'check_out_lng': lng.toString(),
      'check_out_address': address,
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal melakukan Check Out.');
    }
  }
}
