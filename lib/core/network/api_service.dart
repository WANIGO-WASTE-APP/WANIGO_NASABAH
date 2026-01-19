import 'package:flutter/foundation.dart';
import 'package:wanigo_nasabah/core/network/http_client.dart';

class ApiService {
  final HttpClient _httpClient = HttpClient();

  // Base URL dari API tanpa /api di akhir (sesuai dengan gambar Postman dan error 404)
  final String _baseUrl = 'https://api.wanigo.id';

  // Timeout constants
  static const Duration _defaultTimeout = Duration(seconds: 45);
  static const Duration _longTimeout = Duration(seconds: 60);

  // Check email API - untuk pengecekan apakah email sudah terdaftar
  Future<Map<String, dynamic>> checkEmail(String email) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Check Email Request with email: $email");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/check-email
      final response = await _httpClient.post(
        '$_baseUrl/api/check-email',
        {
          'email': email,
        },
      ).timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Check Email API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Check Email API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Login API - untuk login dengan email dan password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Login Request with email: $email");
        print("DEBUG - Password length: ${password.length}");
      }

      // Pastikan format request body sesuai dengan API
      final response = await _httpClient.post(
        '$_baseUrl/api/login',
        {
          'email': email,
          'password': password,
        },
      ).timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Login API Response Status: ${response['status']}");
        print("DEBUG - Login API Raw Response: $response");
      }

      // Standarisasi format response
      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'] ?? {},
        'statusMessage': response['message'] ?? 'No message provided',
      };

      // Log untuk debug
      if (kDebugMode) {
        if (standardizedResponse['success']) {
          print(
              "DEBUG - Login success, user role: ${standardizedResponse['data']['user']['role']}");
          print(
              "DEBUG - Token received: ${standardizedResponse['data']['access_token'] != null}");
        } else {
          print(
              "DEBUG - Login failed: ${standardizedResponse['statusMessage']}");
        }
      }

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Login API Exception: $e");
      }

      return {'success': false, 'statusMessage': e.toString(), 'data': {}};
    }
  }

  // Register API - untuk pendaftaran user baru
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Register Request with email: $email");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/register
      final response = await _httpClient.post(
        '$_baseUrl/api/register',
        {
          'name': name,
          'email': email,
          'phone_number': phone,
          'password': password,
          'password_confirmation': password,
          'role': 'nasabah',
        },
      ).timeout(_longTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Register API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Register API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Forgot Password API - untuk reset password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Forgot Password Request with email: $email");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/forgot-password
      final response = await _httpClient.post(
        '$_baseUrl/api/forgot-password',
        {
          'email': email,
        },
      ).timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Forgot Password API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Forgot Password API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Reset Password API - untuk reset password dengan token
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Reset Password Request with email: $email");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/reset-password
      final response = await _httpClient.post(
        '$_baseUrl/api/reset-password',
        {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      ).timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Reset Password API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Reset Password API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Logout API - untuk logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/logout
      final response = await _httpClient
          .post(
        '$_baseUrl/api/logout',
        {},
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Logout API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Logout API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Check Profile Status API - untuk mengecek status kelengkapan profil
  Future<Map<String, dynamic>> checkProfileStatus() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Check Profile Status Request");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/profile-status
      final response = await _httpClient
          .get(
        '$_baseUrl/api/profile-status',
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Check Profile Status API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Check Profile Status API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Get Nasabah Profile API - untuk mendapatkan profil nasabah
  Future<Map<String, dynamic>> getNasabahProfile() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile Request");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/nasabah/profile
      final response = await _httpClient
          .get(
        '$_baseUrl/api/nasabah/profile',
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Update Profile Step 1 API - untuk mengupdate profil step 1
  Future<Map<String, dynamic>> updateProfileStep1({
    required String jenisKelamin,
    required String usia,
    required String profesi,
  }) async {
    try {
      if (kDebugMode) {
        print(
            "DEBUG - Update Profile Step 1 Request with data: jenis_kelamin=$jenisKelamin, usia=$usia, profesi=$profesi");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/nasabah/profile/step1
      final response = await _httpClient
          .post(
        '$_baseUrl/api/nasabah/profile/step1',
        {
          'jenis_kelamin': jenisKelamin,
          'usia': usia,
          'profesi': profesi,
        },
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 1 Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 1 Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Update Profile Step 2 API - untuk mengupdate profil step 2
  Future<Map<String, dynamic>> updateProfileStep2({
    required String tahuMemilahSampah,
    required String motivasiMemilahSampah,
    required String nasabahBankSampah,
    String? kodeBankSampah,
  }) async {
    try {
      if (kDebugMode) {
        print(
            "DEBUG - Update Profile Step 2 Request with data: tahu_memilah_sampah=$tahuMemilahSampah, motivasi_memilah_sampah=$motivasiMemilahSampah, nasabah_bank_sampah=$nasabahBankSampah");
      }

      final Map<String, dynamic> requestBody = {
        'tahu_memilah_sampah': tahuMemilahSampah,
        'motivasi_memilah_sampah': motivasiMemilahSampah,
        'nasabah_bank_sampah': nasabahBankSampah,
      };

      if (kodeBankSampah != null && kodeBankSampah.isNotEmpty) {
        requestBody['kode_bank_sampah'] = kodeBankSampah;
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/nasabah/profile/step2
      final response = await _httpClient
          .post(
        '$_baseUrl/api/nasabah/profile/step2',
        requestBody,
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 2 Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 2 Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Update Profile Step 3 API - untuk mengupdate profil step 3
  Future<Map<String, dynamic>> updateProfileStep3({
    required String frekuensiMemilahSampah,
    required String jenisSampahDikelola,
  }) async {
    try {
      if (kDebugMode) {
        print(
            "DEBUG - Update Profile Step 3 Request with data: frekuensi_memilah_sampah=$frekuensiMemilahSampah, jenis_sampah_dikelola=$jenisSampahDikelola");
      }

      // Perbaikan: URL sesuai dengan dokumentasi Taskflow 1 - /api/nasabah/profile/step3
      final response = await _httpClient
          .post(
        '$_baseUrl/api/nasabah/profile/step3',
        {
          'frekuensi_memilah_sampah': frekuensiMemilahSampah,
          'jenis_sampah_dikelola': jenisSampahDikelola,
        },
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 3 Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 3 Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Get Member Bank Sampah API
  Future<Map<String, dynamic>> getMemberBankSampah() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah Request");
      }

      final response = await _httpClient
          .get(
        '$_baseUrl/api/nasabah/member-bank-sampah',
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }

  // Get Nasabah Bank Sampah Detail API
  Future<Map<String, dynamic>> getNasabahBankSampahDetail(int id) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Bank Sampah Detail Request with ID: $id");
      }

      final response = await _httpClient
          .get(
        '$_baseUrl/api/nasabah/bank-sampah/$id',
        withToken: true,
      )
          .timeout(_defaultTimeout, onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      if (kDebugMode) {
        print("DEBUG - Get Nasabah Bank Sampah Detail API Response: $response");
      }

      final Map<String, dynamic> standardizedResponse = {
        'success': response['status'] == 'success',
        'data': response['data'],
        'statusMessage': response['message'],
      };

      return standardizedResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Bank Sampah Detail API Exception: $e");
      }

      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    }
  }
}
