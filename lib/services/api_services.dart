import 'dart:convert';
import 'package:absen_dulu/models/error_response_model.dart';
import 'package:absen_dulu/models/history_item_model.dart';
import 'package:absen_dulu/models/register_data_model.dart';
import 'package:absen_dulu/services/pref_handler.dart';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://absen.quidi.id';

  Future<dynamic> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final RegisterData responsedata = RegisterData.fromJson(
        jsonDecode(response.body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        PreferenceHandler.saveToken(responsedata.data!.token.toString());
        return registerDataFromJson(response.body);
      } else {
        print('Error body: ${response.body}');
        return errorResponseFromJson(response.body);
      }
    } catch (e) {
      throw Exception('Gagal melakukan request: $e');
    }
  }

  Future<dynamic> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      final RegisterData responsedata = RegisterData.fromJson(
        jsonDecode(response.body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        PreferenceHandler.saveToken(responsedata.data!.token.toString());
        PreferenceHandler.saveEmail(responsedata.data!.user!.email.toString());
        PreferenceHandler.saveName(responsedata.data!.user!.name.toString());

        print(responsedata.data!.token.toString());
        return registerDataFromJson(response.body);
      } else {
        print('Error body: ${response.body}');
        return errorResponseFromJson(response.body);
      }
    } catch (e) {
      throw Exception('Gagal melakukan request: $e');
    }
  }

  Future<List<HistoryItem>> getHistory() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/api/absen/history');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> dataList = decoded['data'];
        return dataList.map((json) => HistoryItem.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
