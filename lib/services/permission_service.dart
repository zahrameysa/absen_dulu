import 'dart:convert';
import 'package:absen_dulu/services/pref_handler.dart';
import 'package:http/http.dart' as http;

class PermissionService {
  final String baseUrl = 'http://absen.quidi.id/api';

  Future<Map<String, dynamic>> submitPermission({
    required double lat,
    required double lng,
    required String address,
    required String reason,
  }) async {
    final String token = await PreferenceHandler.getToken();

    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final url = Uri.parse('$baseUrl/absen/check-in');

    final body = {
      'check_in_lat': lat.toString(),
      'check_in_lng': lng.toString(),
      'check_in_address': address,
      'status': 'izin',
      'alasan_izin': reason,
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: body,
    );
    print(token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengajukan izin.');
    }
  }
}
