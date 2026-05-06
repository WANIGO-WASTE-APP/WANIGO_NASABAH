import 'dart:convert';
import 'dart:math' as math; // Gunakan dart:math bukan Math langsung
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wanigo_nasabah/core/config/alice_config.dart';
import 'package:alice_dio/alice_dio_adapter.dart';

class HttpClient {
  // Token key in secure storage
  static const String _tokenKey = 'auth_token';

  // Secure storage instance
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final Dio _dio;

  HttpClient() {
    _dio = Dio();

    // Alice Interceptor
    final aliceAdapter = AliceDioAdapter();
    alice.addAdapter(aliceAdapter);
    _dio.interceptors.add(aliceAdapter);
  }

  // Default timeout untuk HTTP requests
  static const Duration defaultTimeout = Duration(seconds: 45);
  static const Duration longTimeout = Duration(seconds: 60);

  // HTTP headers
  Map<String, String> _getHeaders({bool withToken = false, String? token}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With':
          'XMLHttpRequest', // Tambahkan header untuk APIs Laravel
    };

    if (withToken && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Check token
  Future<bool> hasToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Error checking token: $e");
      }
      return false;
    }
  }

  // Get token from secure storage
  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (kDebugMode) {
        if (token != null && token.isNotEmpty) {
          // Gunakan math.min dari dart:math
          print(
              "DEBUG - Token retrieved: Yes (${token.substring(0, math.min(10, token.length))}...)");
        } else {
          print("DEBUG - Token retrieved: No");
        }
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Error getting token: $e");
      }
      return null;
    }
  }

  // Save token to secure storage
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      if (kDebugMode) {
        // Gunakan math.min dari dart:math
        print(
            "DEBUG - Token saved successfully: ${token.substring(0, math.min(10, token.length))}...");
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Error saving token: $e");
      }
      throw Exception('Failed to save token: $e');
    }
  }

  // Delete token from secure storage
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      if (kDebugMode) {
        print("DEBUG - Token deleted successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Error deleting token: $e");
      }
      throw Exception('Failed to delete token: $e');
    }
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool withToken = false,
    Duration timeout = defaultTimeout,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      String? token;
      if (withToken) {
        token = await getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
      }

      final headers = _getHeaders(withToken: withToken, token: token);

      // Tambahkan additional headers jika ada
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      if (kDebugMode) {
        print("DEBUG - GET Request: $url");
        if (queryParameters != null) {
          print("DEBUG - Query Parameters: $queryParameters");
        }
        print("DEBUG - Headers: $headers");
      }

      final startTime = DateTime.now();
      final Response dioResponse = await _dio
          .get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      )
          .timeout(timeout, onTimeout: () {
        throw Exception(
            'Koneksi terputus: Server tidak merespon dalam waktu yang ditentukan (${timeout.inSeconds}s)');
      });

      final endTime = DateTime.now();
      final requestDuration = endTime.difference(startTime);

      if (kDebugMode) {
        print(
            "DEBUG - GET Request completed in ${requestDuration.inMilliseconds}ms");
      }

      final dynamic data = dioResponse.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, dioResponse.statusCode ?? 500);

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, 'Gagal mengambil data');
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - GET Request Error: $e");
      }

      if (e.toString().contains('Timeout') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return {
          'status': 'error',
          'message':
              'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
          'data': null
        };
      }

      return {
        'status': 'error',
        'message': 'Gagal mengambil data: ${e.toString()}',
        'data': null
      };
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool withToken = false,
    Duration timeout = defaultTimeout,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      String? token;
      if (withToken) {
        token = await getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
      }

      final headers = _getHeaders(withToken: withToken, token: token);

      // Tambahkan additional headers jika ada
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final encodedBody = json.encode(body);

      if (kDebugMode) {
        print("DEBUG - POST Request: $url");
        print("DEBUG - Headers: $headers");
        // Print body dengan format yang lebih aman (terutama untuk password)
        final Map<String, dynamic> safeBody = Map.from(body);
        if (safeBody.containsKey('password')) {
          safeBody['password'] = '***';
        }
        if (safeBody.containsKey('password_confirmation')) {
          safeBody['password_confirmation'] = '***';
        }
        print("DEBUG - Body: ${json.encode(safeBody)}");
      }

      final startTime = DateTime.now();
      final Response dioResponse = await _dio
          .post(
        url,
        data: encodedBody,
        options: Options(
          headers: headers,
        ),
      )
          .timeout(timeout, onTimeout: () {
        throw Exception(
            'Koneksi terputus: Server tidak merespon dalam waktu yang ditentukan (${timeout.inSeconds}s)');
      });

      final endTime = DateTime.now();
      final requestDuration = endTime.difference(startTime);

      if (kDebugMode) {
        print(
            "DEBUG - POST Request completed in ${requestDuration.inMilliseconds}ms");
      }

      final dynamic data = dioResponse.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, dioResponse.statusCode ?? 500);

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, 'Gagal mengirim data');
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - POST Request Error: $e");
      }

      if (e.toString().contains('Timeout') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return {
          'status': 'error',
          'message':
              'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
          'data': null
        };
      }

      return {
        'status': 'error',
        'message': 'Gagal mengirim data: ${e.toString()}',
        'data': null
      };
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool withToken = false,
    Duration timeout = defaultTimeout,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      String? token;
      if (withToken) {
        token = await getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
      }

      final headers = _getHeaders(withToken: withToken, token: token);

      // Tambahkan additional headers jika ada
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final encodedBody = json.encode(body);

      if (kDebugMode) {
        print("DEBUG - PUT Request: $url");
        print("DEBUG - Headers: $headers");
        print("DEBUG - Body: $encodedBody");
      }

      final startTime = DateTime.now();
      final Response dioResponse = await _dio
          .put(
        url,
        data: encodedBody,
        options: Options(
          headers: headers,
        ),
      )
          .timeout(timeout, onTimeout: () {
        throw Exception(
            'Koneksi terputus: Server tidak merespon dalam waktu yang ditentukan (${timeout.inSeconds}s)');
      });

      final endTime = DateTime.now();
      final requestDuration = endTime.difference(startTime);

      if (kDebugMode) {
        print(
            "DEBUG - PUT Request completed in ${requestDuration.inMilliseconds}ms");
      }

      final dynamic data = dioResponse.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, dioResponse.statusCode ?? 500);

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, 'Gagal mengupdate data');
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - PUT Request Error: $e");
      }

      if (e.toString().contains('Timeout') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return {
          'status': 'error',
          'message':
              'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
          'data': null
        };
      }

      return {
        'status': 'error',
        'message': 'Gagal mengupdate data: ${e.toString()}',
        'data': null
      };
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    bool withToken = false,
    Duration timeout = defaultTimeout,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      String? token;
      if (withToken) {
        token = await getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
      }

      final headers = _getHeaders(withToken: withToken, token: token);

      // Tambahkan additional headers jika ada
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      if (kDebugMode) {
        print("DEBUG - DELETE Request: $url");
        print("DEBUG - Headers: $headers");
      }

      final startTime = DateTime.now();
      final Response dioResponse = await _dio
          .delete(
        url,
        options: Options(
          headers: headers,
        ),
      )
          .timeout(timeout, onTimeout: () {
        throw Exception(
            'Koneksi terputus: Server tidak merespon dalam waktu yang ditentukan (${timeout.inSeconds}s)');
      });

      final endTime = DateTime.now();
      final requestDuration = endTime.difference(startTime);

      if (kDebugMode) {
        print(
            "DEBUG - DELETE Request completed in ${requestDuration.inMilliseconds}ms");
      }

      final dynamic data = dioResponse.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, dioResponse.statusCode ?? 500);

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, 'Gagal menghapus data');
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - DELETE Request Error: $e");
      }

      if (e.toString().contains('Timeout') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return {
          'status': 'error',
          'message':
              'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
          'data': null
        };
      }

      return {
        'status': 'error',
        'message': 'Gagal menghapus data: ${e.toString()}',
        'data': null
      };
    }
  }

  // PATCH request
  Future<Map<String, dynamic>> patch(
    String url,
    Map<String, dynamic> body, {
    bool withToken = false,
    Duration timeout = defaultTimeout,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      String? token;
      if (withToken) {
        token = await getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
      }

      final headers = _getHeaders(withToken: withToken, token: token);

      // Tambahkan additional headers jika ada
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final encodedBody = json.encode(body);

      if (kDebugMode) {
        print("DEBUG - PATCH Request: $url");
        print("DEBUG - Headers: $headers");
        print("DEBUG - Body: $encodedBody");
      }

      final startTime = DateTime.now();
      final Response dioResponse = await _dio
          .patch(
        url,
        data: encodedBody,
        options: Options(
          headers: headers,
        ),
      )
          .timeout(timeout, onTimeout: () {
        throw Exception(
            'Koneksi terputus: Server tidak merespon dalam waktu yang ditentukan (${timeout.inSeconds}s)');
      });

      final endTime = DateTime.now();
      final requestDuration = endTime.difference(startTime);

      if (kDebugMode) {
        print(
            "DEBUG - PATCH Request completed in ${requestDuration.inMilliseconds}ms");
      }

      final dynamic data = dioResponse.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, dioResponse.statusCode ?? 500);

      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, 'Gagal mengupdate data');
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - PATCH Request Error: $e");
      }

      if (e.toString().contains('Timeout') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return {
          'status': 'error',
          'message':
              'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
          'data': null
        };
      }

      return {
        'status': 'error',
        'message': 'Gagal mengupdate data: ${e.toString()}',
        'data': null
      };
    }
  }

  // Handle DioException helper
  Map<String, dynamic> _handleDioException(
      DioException e, String defaultErrorMessage) {
    if (kDebugMode) {
      print("DEBUG - DioException handled: ${e.type}, message: ${e.message}");
      if (e.response != null) {
        print(
            "DEBUG - DioException response status: ${e.response?.statusCode}");
        print("DEBUG - DioException response data: ${e.response?.data}");
      }
    }

    if (e.response != null) {
      final dynamic data = e.response!.data;
      final String bodyString = data is String ? data : json.encode(data ?? {});
      final http.Response response =
          http.Response(bodyString, e.response!.statusCode ?? 500);
      return _processResponse(response);
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.error.toString().contains('SocketException')) {
      return {
        'status': 'error',
        'message':
            'Koneksi terputus: Server tidak dapat dijangkau. Silakan periksa koneksi internet Anda.',
        'data': null
      };
    }

    return {
      'status': 'error',
      'message': '$defaultErrorMessage: ${e.message ?? e.toString()}',
      'data': null
    };
  }

  // Process HTTP response
  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      if (kDebugMode) {
        print("DEBUG - Response Status Code: ${response.statusCode}");

        // Batasi panjang response body yang ditampilkan di log
        final bodyPreview = response.body.length > 1000
            ? '${response.body.substring(0, 1000)}...'
            : response.body;

        print("DEBUG - Response Body Preview: $bodyPreview");
      }

      // Tambahkan penanganan untuk respons kosong
      if (response.body.isEmpty) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return {
            'status': 'success',
            'message': 'Success with empty response',
            'data': null
          };
        } else {
          return {
            'status': 'error',
            'message': 'Error with empty response: ${response.statusCode}',
            'data': null
          };
        }
      }

      // Penanganan respons JSON
      try {
        final Map<String, dynamic> responseJson = json.decode(response.body);

        // Log untuk debugging
        if (kDebugMode) {
          if (responseJson.containsKey('status')) {
            print("DEBUG - Response status: ${responseJson['status']}");
          }

          if (responseJson.containsKey('message')) {
            print("DEBUG - Response message: ${responseJson['message']}");
          }

          if (responseJson.containsKey('data')) {
            if (responseJson['data'] != null) {
              print(
                  "DEBUG - Response contains data: ${responseJson['data'] is Map ? 'Map' : 'List or other type'}");

              // Debugging untuk response login/register
              if (responseJson['data'] is Map &&
                  responseJson['data'].containsKey('user')) {
                final user = responseJson['data']['user'];
                print(
                    "DEBUG - User data: id=${user['id']}, role=${user['role']}");
              }

              if (responseJson['data'] is Map &&
                  responseJson['data'].containsKey('access_token')) {
                final token = responseJson['data']['access_token'];
                if (token != null && token.toString().isNotEmpty) {
                  // Gunakan math.min dari dart:math
                  print(
                      "DEBUG - Token received: ${token.toString().substring(0, math.min(10, token.toString().length))}...");
                } else {
                  print("DEBUG - Token received but empty");
                }
              }

              if (responseJson['data'] is Map &&
                  responseJson['data'].containsKey('profile_status')) {
                final profileStatus = responseJson['data']['profile_status'];
                print("DEBUG - Profile status: $profileStatus");
              }
            } else {
              print("DEBUG - Response data is null");
            }
          }

          if (responseJson.containsKey('errors')) {
            print(
                "DEBUG - Response contains errors: ${responseJson['errors']}");
          }
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Standardize response format sesuai dengan yang diharapkan API WANIGO
          if (!responseJson.containsKey('status')) {
            responseJson['status'] = 'success';
          }

          if (!responseJson.containsKey('message') &&
              responseJson['status'] == 'success') {
            responseJson['message'] = 'Operation successful';
          }

          return responseJson;
        } else {
          // Handle different error status codes
          String errorMessage = 'Server error: ${response.statusCode}';

          if (responseJson.containsKey('message')) {
            errorMessage = responseJson['message'];
          } else if (responseJson.containsKey('error')) {
            errorMessage = responseJson['error'];
          }

          // Mapping error code ke error user-friendly
          switch (response.statusCode) {
            case 401:
              errorMessage = 'Akses ditolak: Silakan login kembali';
              break;
            case 403:
              errorMessage =
                  'Akses ditolak: Anda tidak memiliki izin untuk operasi ini';
              break;
            case 404:
              errorMessage = 'Data tidak ditemukan';
              break;
            case 422:
              errorMessage = 'Validasi gagal';
              if (responseJson.containsKey('errors') &&
                  responseJson['errors'] is Map) {
                final Map<String, dynamic> errors =
                    Map<String, dynamic>.from(responseJson['errors']);

                // Hindari Bad state: No element (jangan akses .first jika kosong)
                if (errors.isNotEmpty && errors.values.isNotEmpty) {
                  // Ambil pesan error pertama dari field pertama yang bermasalah
                  final firstFieldErrors = errors.values.first;
                  if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
                    errorMessage = firstFieldErrors.first.toString();
                  } else if (firstFieldErrors is String &&
                      firstFieldErrors.trim().isNotEmpty) {
                    errorMessage = firstFieldErrors;
                  }
                }
              } else if (responseJson.containsKey('message')) {
                errorMessage = responseJson['message'];
              }
              break;
            case 500:
              errorMessage = 'Terjadi kesalahan pada server';
              break;
          }

          // Handle error responses with standard format
          return {
            'status': 'error',
            'message': errorMessage,
            'errors': responseJson['errors'],
            'statusCode': response.statusCode,
          };
        }
      } catch (e) {
        // Handle non-JSON responses
        if (kDebugMode) {
          print("DEBUG - Failed to decode JSON: $e");
        }

        // Response status code specific messages
        switch (response.statusCode) {
          case 404:
            return {
              'status': 'error',
              'message': 'Endpoint tidak ditemukan: 404',
              'data': null,
              'statusCode': response.statusCode,
            };
          case 400:
            return {
              'status': 'error',
              'message':
                  'Permintaan tidak valid: Periksa format permintaan Anda',
              'data': null,
              'statusCode': response.statusCode,
            };
          case 401:
            return {
              'status': 'error',
              'message': 'Akses ditolak: Silakan login kembali',
              'data': null,
              'statusCode': response.statusCode,
            };
          case 403:
            return {
              'status': 'error',
              'message':
                  'Akses ditolak: Anda tidak memiliki izin untuk operasi ini',
              'data': null,
              'statusCode': response.statusCode,
            };
          case 429:
            return {
              'status': 'error',
              'message': 'Terlalu banyak permintaan: Silakan coba lagi nanti',
              'data': null,
              'statusCode': response.statusCode,
            };
          case 500:
          case 502:
          case 503:
          case 504:
            return {
              'status': 'error',
              'message':
                  'Terjadi kesalahan pada server: Silakan coba lagi nanti',
              'data': null,
              'statusCode': response.statusCode,
            };
          default:
            return {
              'status': 'error',
              'message':
                  'Server returned ${response.statusCode} with non-JSON response',
              'data': null,
              'statusCode': response.statusCode,
            };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Failed to process response: $e");
        print("DEBUG - Response Status: ${response.statusCode}");

        // Batasi panjang response body yang ditampilkan di log
        final bodyPreview = response.body.length > 500
            ? '${response.body.substring(0, 500)}...'
            : response.body;

        print("DEBUG - Response Body Preview: $bodyPreview");
      }

      // Generic error response berdasarkan status code
      String errorMessage = 'Terjadi kesalahan pada aplikasi';

      switch (response.statusCode) {
        case 401:
          errorMessage = 'Akses ditolak: Silakan login kembali';
          break;
        case 403:
          errorMessage =
              'Akses ditolak: Anda tidak memiliki izin untuk operasi ini';
          break;
        case 404:
          errorMessage = 'Data tidak ditemukan';
          break;
        case 422:
          errorMessage =
              'Validasi gagal: Periksa kembali data yang Anda masukkan';
          break;
        case 500:
        case 502:
        case 503:
        case 504:
          errorMessage = 'Terjadi kesalahan pada server';
          break;
      }

      return {
        'status': 'error',
        'message': errorMessage,
        'statusCode': response.statusCode,
      };
    }
  }
}
