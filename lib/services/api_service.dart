// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import semua model data yang dibutuhkan
import '../kkpr/jeniskkpr/berusaha/data_kkpr_berusaha.dart';
import '../kkpr/jeniskkpr/nonberusaha/data_kkpr_nonberusaha.dart';

class ApiService {
  static const String _baseUrl = 'https://ti054b02api.agussbn.my.id/api';

  // =============================================
  // ==             HELPER INTERNAL             ==
  // =============================================

  Future<Map<String, String>> _getAuthenticatedHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final idAdmin = prefs.getInt('id_admin');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (token != null) headers['Authorization'] = 'Bearer $token';
    if (idAdmin != null && idAdmin != 0)
      headers['idAdmin'] = idAdmin.toString();
    return headers;
  }

  Future<Map<String, String>> _getMultipartHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final idUser = prefs.getInt('user_id');
    final headers = {'Accept': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    if (idUser != null) headers['X-User-ID'] = idUser.toString();
    return headers;
  }

  // =============================================
  // ==        FUNGSI OTENTIKASI & UMUM         ==
  // =============================================

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          final userData = responseData['data'];
          await prefs.setString('token', userData['token'] ?? '');
          await prefs.setString('role', userData['role_name'] ?? '');
          await prefs.setInt('user_id', userData['id_user'] ?? 0);
          if (userData['id_admin'] != null) {
            await prefs.setInt('id_admin', userData['id_admin']);
          } else {
            await prefs.remove('id_admin');
          }
          return userData;
        } else {
          throw Exception(responseData['message'] ?? 'Login gagal.');
        }
      } else {
        throw Exception(
          responseData['message'] ?? 'Username atau password tidak valid.',
        );
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<Map<String, dynamic>>> getSektors() async {
    final url = Uri.parse('$_baseUrl/sektor');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  Future<void> deleteKkpr(int id) async {
    final url = Uri.parse('$_baseUrl/hapusKKPR/$id');
    final headers = await _getAuthenticatedHeaders();
    final response = await http.delete(url, headers: headers);
    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Gagal menghapus data.');
    }
  }

  // =============================================
  // ==        FUNGSI-FUNGSI KKPR BERUSAHA      ==
  // =============================================

  Future<List<KkprData>> getKkprBerusaha() async {
    final url = Uri.parse('$_baseUrl/getDataKKPRBerusaha');
    final headers = await _getAuthenticatedHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> listData = data['data'];
        return listData.map((json) => KkprData.fromJson(json)).toList();
      } else {
        throw Exception('API Error: ${data['message'] ?? 'Gagal memuat data'}');
      }
    } else {
      throw Exception(
        'Gagal terhubung ke server (Error: ${response.statusCode})',
      );
    }
  }

  Future<void> addKkprBerusaha(
    Map<String, String> data, {
    String? filePath,
  }) async {
    final url = Uri.parse('$_baseUrl/storeKKPRBerusaha');
    final headers = await _getMultipartHeaders();
    var request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('user_id');
    if (idUser != null) data['id_user'] = idUser.toString();
    request.headers.addAll(headers);
    request.fields.addAll(data);
    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file_csv', filePath),
      );
    }
    final response = await request.send();
    if (response.statusCode >= 300) {
      final respStr = await response.stream.bytesToString();
      throw Exception(jsonDecode(respStr)['message'] ?? 'Gagal menyimpan data');
    }
  }

  // PERBAIKAN DI FUNGSI INI
  Future<KkprData> getKkprDetail(int id) async {
    final url = Uri.parse('$_baseUrl/tampilBerusaha/$id');
    final headers = await _getAuthenticatedHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Cek jika ada key 'data', gunakan itu. Jika tidak, gunakan seluruh object.
      final detailData = data['data'] ?? data;
      if (detailData is Map<String, dynamic>) {
        return KkprData.fromJson(detailData);
      } else {
        throw Exception('Format data detail tidak sesuai.');
      }
    } else {
      throw Exception('Gagal memuat detail data.');
    }
  }

  Future<void> updateKkprBerusaha(
    int id,
    Map<String, String> data, {
    String? filePath,
  }) async {
    final url = Uri.parse('$_baseUrl/updateBerusaha/$id');
    final headers = await _getMultipartHeaders();
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll(data);
    request.fields['_method'] = 'PUT';
    request.headers.addAll(headers);
    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file_csv', filePath),
      );
    }
    final response = await request.send();
    if (response.statusCode >= 300) {
      final respStr = await response.stream.bytesToString();
      throw Exception(
        jsonDecode(respStr)['message'] ?? 'Gagal mengupdate data',
      );
    }
  }

  // =============================================
  // ==     FUNGSI-FUNGSI KKPR NON BERUSAHA     ==
  // =============================================

  Future<List<KkprNonBerusahaData>> getKkprNonBerusaha() async {
    final url = Uri.parse('$_baseUrl/getDataKKPRNonBerusaha');
    final headers = await _getAuthenticatedHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> listData = data['data'];
        return listData
            .map((json) => KkprNonBerusahaData.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'API Error: ${data['message'] ?? 'Gagal memuat data Non Berusaha'}',
        );
      }
    } else {
      throw Exception(
        'Gagal terhubung ke server (Error: ${response.statusCode})',
      );
    }
  }

  Future<void> addKkprNonBerusaha(
    Map<String, String> data, {
    String? filePath,
  }) async {
    final url = Uri.parse('$_baseUrl/storeKKPRNonBerusaha');
    final headers = await _getMultipartHeaders();
    var request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('user_id');
    if (idUser != null) data['id_user'] = idUser.toString();
    request.headers.addAll(headers);
    request.fields.addAll(data);
    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file_csv', filePath),
      );
    }
    final response = await request.send();
    if (response.statusCode >= 300) {
      final respStr = await response.stream.bytesToString();
      throw Exception(jsonDecode(respStr)['message'] ?? 'Gagal menyimpan data');
    }
  }

  // PERBAIKAN DI FUNGSI INI JUGA
  Future<KkprNonBerusahaData> getKkprNonBerusahaDetail(int id) async {
    final url = Uri.parse('$_baseUrl/tampilNonBerusaha/$id');
    final headers = await _getAuthenticatedHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Cek jika ada key 'data', gunakan itu. Jika tidak, gunakan seluruh object.
      final detailData = data['data'] ?? data;
      if (detailData is Map<String, dynamic>) {
        return KkprNonBerusahaData.fromJson(detailData);
      } else {
        throw Exception('Format data detail tidak sesuai.');
      }
    } else {
      throw Exception(
        'Gagal memuat detail data (Error: ${response.statusCode})',
      );
    }
  }

  Future<void> updateKkprNonBerusaha(
    int id,
    Map<String, String> data, {
    String? filePath,
  }) async {
    final url = Uri.parse('$_baseUrl/updateNonBerusaha/$id');
    final headers = await _getMultipartHeaders();
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll(data);
    request.fields['_method'] = 'PUT';
    request.headers.addAll(headers);
    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file_csv', filePath),
      );
    }
    final response = await request.send();
    if (response.statusCode >= 300) {
      final respStr = await response.stream.bytesToString();
      throw Exception(
        jsonDecode(respStr)['message'] ?? 'Gagal mengupdate data',
      );
    }
  }
}
