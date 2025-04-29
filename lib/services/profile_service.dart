import 'dart:convert';
import 'package:absen_dulu/models/profile_response.dart';
import 'package:http/http.dart' as http;
import 'package:absen_dulu/services/pref_handler.dart';

class ProfileService {
  final String baseUrl = 'https://absen.quidi.id/api';

  Future<void> updateProfile({required String name}) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/profile');

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'name': name},
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to update profile.');
    }
  }

  Future<Profileresponse> fetchProfile() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/profile');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return profileresponseFromJson(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
