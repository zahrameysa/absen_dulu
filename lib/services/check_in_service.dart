import 'dart:convert';
import 'package:absen_dulu/services/pref_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckInService {
  final String baseUrl = 'http://absen.quidi.id/api'; // Ganti kalau nanti perlu

  Future<Map<String, dynamic>> checkIn({
    required double lat,
    required double lng,
    required String address,
    String status = 'masuk', // default check in masuk
    String? alasanIzin, // opsional kalau izin
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
      'status': status, // "masuk" atau "izin"
    };

    if (status == 'izin' && alasanIzin != null) {
      body['alasan_izin'] = alasanIzin;
    }

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal melakukan Check In.');
    }
  }
}
