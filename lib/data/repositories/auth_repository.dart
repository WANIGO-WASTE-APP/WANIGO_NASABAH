import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanigo_nasabah/core/network/http_client.dart';
import 'package:wanigo_nasabah/data/models/auth_models.dart';
import 'package:wanigo_nasabah/core/network/api_service.dart';
import 'package:wanigo_nasabah/data/models/member_bank_sampah_response.dart';

// ... other imports ...

// ... inside AuthRepository class ...

/// Get Member Bank Sampah
// ... other imports ...

/// Repository untuk autentikasi
/// Kelas ini menangani interaksi dengan API terkait autentikasi
/// dan juga pengelolaan token dan data user lokal
class AuthRepository {
  // API Service untuk request ke server
  final ApiService _apiService = ApiService();

  // HTTP Client untuk pengelolaan token
  final HttpClient _httpClient = HttpClient();

  /// Get Member Bank Sampah
  Future<MemberBankSampahResponse?> getMemberBankSampah() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah Request");
      }

      final response = await _apiService.getMemberBankSampah();

      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah Repository Response: $response");
      }

      if (response['success'] == true) {
        final data = response['data'];
        return MemberBankSampahResponse.fromJson(data);
      } else {
        return null; // Or throw exception if preferred
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Member Bank Sampah Repository Exception: $e");
      }
      return null;
    }
  }

  // Key untuk penyimpanan lokal
  static const String _userKey = 'user_data';
  static const String _profileStatusKey = 'profile_status';

  /// Memeriksa apakah email sudah terdaftar
  Future<Map<String, dynamic>> checkEmail(String email) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Check Email Request with email: $email");
        // Berikan delay kecil untuk mencegah UI freeze
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final response = await _apiService.checkEmail(email);

      if (kDebugMode) {
        print("DEBUG - Check Email Repository Response: $response");
      }

      // Untuk menghindari format respons yang berbeda, standarisasi format respons
      Map<String, dynamic> standardResponse = {
        'status': 'error',
        'message': 'Unknown error occurred',
        'data': null
      };

      // Cek bila success dengan format yang diharapkan
      if (response['success'] == true && response['data'] != null) {
        Map<String, dynamic> data = response['data'];

        // Format respons baru sesuai dengan API docs
        if (data.containsKey('status')) {
          standardResponse['status'] = data['status'];

          if (data.containsKey('message')) {
            standardResponse['message'] = data['message'];
          }

          if (data.containsKey('data') && data['data'] != null) {
            standardResponse['data'] = data['data'];
          }

          return standardResponse;
        }

        // Format respons lama (masih mungkin dipakai)
        standardResponse['status'] = 'success';

        if (data.containsKey('email_exists')) {
          bool emailExists = data['email_exists'] ?? false;
          String? role = data['role'];

          standardResponse['message'] =
              emailExists ? 'Email terdaftar' : 'Email belum terdaftar';
          standardResponse['data'] = {
            'email_exists': emailExists,
            'role': role
          };

          return standardResponse;
        }

        // Jika format data tidak dikenali, gunakan data as-is
        return {
          'status': 'success',
          'message': 'Response received',
          'data': data
        };
      }

      // Handle error case
      standardResponse['message'] = response['statusMessage'] ??
          (response['data'] != null && response['data']['message'] != null
              ? response['data']['message']
              : 'Gagal memeriksa email');

      return standardResponse;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Check Email Repository Exception: $e");
      }

      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'data': null
      };
    }
  }

  /// Login dengan email dan password
// Perbaikan method login di auth_repository.dart
  Future<LoginResponse> login(String email, String password) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Login Request with email: $email");
      }

      final response = await _apiService.login(email, password);

      if (kDebugMode) {
        print("DEBUG - Login Repository Response: $response");
      }

      if (response['success'] == true) {
        // Parse response ke model
        final data = response['data'];

        // Extract user from response
        final userJson = data['user'];
        final UserModel user = UserModel.fromJson(userJson);

        // Extract token
        final String token = data['access_token'];
        final String tokenType = data['token_type'];

        // Extract profile status - PERBAIKAN: Menangani profile_status yang berupa string
        ProfileStatusModel profileStatus;

        if (data.containsKey('profile_status')) {
          final profileStatusData = data['profile_status'];

          if (kDebugMode) {
            print(
                "DEBUG - Profile status data type: ${profileStatusData.runtimeType}");
            print("DEBUG - Profile status data value: $profileStatusData");
          }

          // Jika profile_status adalah string
          if (profileStatusData is String) {
            // Periksa jika string-nya adalah "complete" atau "completed"
            if (profileStatusData == "complete" ||
                profileStatusData == "completed") {
              profileStatus = ProfileStatusModel(
                isCompleted: true,
                completionPercentage: 100,
                nextStep: '',
              );
            } else if (profileStatusData == "incomplete" ||
                profileStatusData == "started") {
              profileStatus = ProfileStatusModel(
                isCompleted: false,
                completionPercentage: 0,
                nextStep: 'step1',
              );
            } else {
              // Default untuk string lainnya
              profileStatus = ProfileStatusModel(
                isCompleted: false,
                completionPercentage: 0,
                nextStep: 'step1',
              );
            }
          }
          // Jika profile_status adalah Map (object)
          else if (profileStatusData is Map) {
            profileStatus = ProfileStatusModel.fromJson(
                profileStatusData as Map<String, dynamic>);
          }
          // Jika profile_status adalah null atau tipe lain
          else {
            profileStatus = ProfileStatusModel(
              isCompleted: false,
              completionPercentage: 0,
              nextStep: 'step1',
            );
          }
        } else {
          // Profile status tidak ada dalam response
          profileStatus = ProfileStatusModel(
            isCompleted: false,
            completionPercentage: 0,
            nextStep: 'step1',
          );
        }

        if (kDebugMode) {
          print(
              "DEBUG - Parsed profile status: isCompleted=${profileStatus.isCompleted}, completionPercentage=${profileStatus.completionPercentage}, nextStep=${profileStatus.nextStep}");
        }

        // Save token to secure storage
        await _httpClient.saveToken(token);

        // Save user data to shared preferences
        await saveUser(user);

        // Save profile status to shared preferences
        await saveProfileStatus(profileStatus);

        // Return login response
        return LoginResponse(
          user: user,
          token: token,
          tokenType: tokenType,
          profileStatus: profileStatus,
        );
      } else {
        // Cek jika ada pesan error
        String errorMessage = 'Gagal login';
        if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('message')) {
          errorMessage = response['data']['message'];
        } else if (response.containsKey('statusMessage')) {
          errorMessage = response['statusMessage'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Login Repository Exception: $e");
      }

      throw Exception(e.toString());
    }
  }

  /// Register nasabah baru
  /// Return RegisterResponse model yang berisi user dan token
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Register Request with email: $email");
      }

      final response = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (kDebugMode) {
        print("DEBUG - Register Repository Response: $response");
      }

      if (response['success'] == true) {
        // Parse response ke model
        final data = response['data'];

        // Extract user from response
        final userJson = data['user'];
        final UserModel user = UserModel.fromJson(userJson);

        // Extract token
        final String token = data['access_token'];
        final String tokenType = data['token_type'];

        // Extract profile status
        final profileStatusJson = data['profile_status'];

        // Profile status bisa berupa string atau objek
        ProfileStatusModel profileStatus;
        if (profileStatusJson is String) {
          // Jika string, buat objek manual
          profileStatus = ProfileStatusModel(
            isCompleted: profileStatusJson == 'completed',
            completionPercentage: profileStatusJson == 'completed' ? 100 : 0,
            nextStep: profileStatusJson == 'completed' ? '' : 'step1',
          );
        } else {
          // Jika objek, parse langsung
          profileStatus = ProfileStatusModel.fromJson(profileStatusJson);
        }

        // Save token to secure storage
        await _httpClient.saveToken(token);

        // Save user data to shared preferences
        await saveUser(user);

        // Save profile status to shared preferences
        await saveProfileStatus(profileStatus);

        // Return register response
        return RegisterResponse(
          user: user,
          token: token,
          tokenType: tokenType,
          profileStatus: profileStatus,
        );
      } else {
        // Cek jika ada pesan error
        String errorMessage = 'Gagal registrasi';
        if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('message')) {
          errorMessage = response['data']['message'];
        } else if (response.containsKey('statusMessage')) {
          errorMessage = response['statusMessage'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Register Repository Exception: $e");
      }

      throw Exception(e.toString());
    }
  }

  /// Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Forgot Password Request with email: $email");
      }

      final response = await _apiService.forgotPassword(email);

      if (kDebugMode) {
        print("DEBUG - Forgot Password Repository Response: $response");
      }

      return response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Forgot Password Repository Exception: $e");
      }

      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print("DEBUG - Reset Password Request with email: $email");
      }

      final response = await _apiService.resetPassword(
        token: token,
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print("DEBUG - Reset Password Repository Response: $response");
      }

      return response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Reset Password Repository Exception: $e");
      }

      return false;
    }
  }

  /// Logout dari aplikasi
  Future<bool> logout() async {
    try {
      // Panggil API logout
      final response = await _apiService.logout();

      if (kDebugMode) {
        print("DEBUG - Logout Repository Response: $response");
      }

      // Hapus token dari secure storage
      await _httpClient.deleteToken();

      // Hapus data user dari shared preferences
      await clearUserData();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Logout Repository Exception: $e");
      }

      // Hapus token dari secure storage meskipun API gagal
      await _httpClient.deleteToken();

      // Hapus data user dari shared preferences
      await clearUserData();

      return false;
    }
  }

  /// Check profile status
  Future<ProfileStatusModel> checkProfileStatus() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Check Profile Status Request");
      }

      final response = await _apiService.checkProfileStatus();

      if (kDebugMode) {
        print("DEBUG - Check Profile Status Repository Response: $response");
      }

      if (response['success'] == true) {
        // Parse response ke model
        final data = response['data'];

        // Extract profile status
        final profileStatusJson = data['profile_status'];
        final ProfileStatusModel profileStatus =
            ProfileStatusModel.fromJson(profileStatusJson);

        // Save profile status to shared preferences
        await saveProfileStatus(profileStatus);

        return profileStatus;
      } else {
        // Return saved profile status or default
        final savedStatus = await getProfileStatus();
        if (savedStatus != null) {
          return savedStatus;
        }

        // Return default if nothing available
        return ProfileStatusModel(
          isCompleted: false,
          completionPercentage: 0,
          nextStep: 'step1',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Check Profile Status Repository Exception: $e");
      }

      // Return saved profile status or default
      final savedStatus = await getProfileStatus();
      if (savedStatus != null) {
        return savedStatus;
      }

      // Return default if nothing available
      return ProfileStatusModel(
        isCompleted: false,
        completionPercentage: 0,
        nextStep: 'step1',
      );
    }
  }

  /// Get nasabah profile
  Future<UserModel> getNasabahProfile() async {
    try {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile Request");
      }

      final response = await _apiService.getNasabahProfile();

      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile Repository Response: $response");
      }

      if (response['success'] == true) {
        // Parse response ke model
        final data = response['data'];

        // Extract user from response
        final userJson = data['user'];
        final UserModel user = UserModel.fromJson(userJson);

        // Save user data to shared preferences
        await saveUser(user);

        // Extract profile status
        if (data.containsKey('profile_status')) {
          final profileStatusJson = data['profile_status'];
          final ProfileStatusModel profileStatus =
              ProfileStatusModel.fromJson(profileStatusJson);

          // Save profile status to shared preferences
          await saveProfileStatus(profileStatus);
        }

        return user;
      } else {
        // Return saved user or throw exception
        final savedUser = await getUser();
        if (savedUser != null) {
          return savedUser;
        } else {
          throw Exception('Failed to get nasabah profile');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Nasabah Profile Repository Exception: $e");
      }

      // Return saved user or throw exception
      final savedUser = await getUser();
      if (savedUser != null) {
        return savedUser;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  /// Update Profile Step 1
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

      // Panggil API dengan ApiService untuk update profil step 1
      final response = await _apiService.updateProfileStep1(
        jenisKelamin: jenisKelamin,
        usia: usia,
        profesi: profesi,
      );

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 1 Response: $response");
      }

      if (response['success'] == true) {
        // Update local user data
        final savedUser = await getUser();
        if (savedUser != null && savedUser.nasabah != null) {
          // Update nasabah properties
          final updatedNasabah = NasabahModel(
            id: savedUser.nasabah!.id,
            userId: savedUser.nasabah!.userId,
            jenisKelamin: jenisKelamin,
            usia: usia,
            profesi: profesi,
            tahuMemilahSampah: savedUser.nasabah!.tahuMemilahSampah,
            motivasiMemilahSampah: savedUser.nasabah!.motivasiMemilahSampah,
            nasabahBankSampah: savedUser.nasabah!.nasabahBankSampah,
            kodeBankSampah: savedUser.nasabah!.kodeBankSampah,
            frekuensiMemilahSampah: savedUser.nasabah!.frekuensiMemilahSampah,
            jenisSampahDikelola: savedUser.nasabah!.jenisSampahDikelola,
            profileCompletedAt: savedUser.nasabah!.profileCompletedAt,
            createdAt: savedUser.nasabah!.createdAt,
            updatedAt: savedUser.nasabah!.updatedAt,
          );

          // Update user model
          final updatedUser = UserModel(
            id: savedUser.id,
            name: savedUser.name,
            email: savedUser.email,
            phoneNumber: savedUser.phoneNumber,
            role: savedUser.role,
            createdAt: savedUser.createdAt,
            updatedAt: savedUser.updatedAt,
            profilePhotoUrl: savedUser.profilePhotoUrl,
            nasabah: updatedNasabah,
          );

          // Save updated user
          await saveUser(updatedUser);

          // Also update profile status if provided in response
          if (response['data'] != null &&
              response['data']['profile_status'] != null) {
            final profileStatus =
                ProfileStatusModel.fromJson(response['data']['profile_status']);
            await saveProfileStatus(profileStatus);
          }
        }

        return {
          'status': 'success',
          'message': 'Profil berhasil diperbarui',
          'data': response['data'],
        };
      } else {
        // Handling response error
        String errorMessage = 'Gagal memperbarui profil';
        if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('message')) {
          errorMessage = response['data']['message'];
        } else if (response.containsKey('statusMessage')) {
          errorMessage = response['statusMessage'];
        }

        return {
          'status': 'error',
          'message': errorMessage,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 1 Exception: $e");
      }

      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  /// Update Profile Step 2
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

      // Panggil API dengan ApiService untuk update profil step 2
      final response = await _apiService.updateProfileStep2(
        tahuMemilahSampah: tahuMemilahSampah,
        motivasiMemilahSampah: motivasiMemilahSampah,
        nasabahBankSampah: nasabahBankSampah,
        kodeBankSampah: kodeBankSampah,
      );

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 2 Response: $response");
      }

      if (response['success'] == true) {
        // Update local user data
        final savedUser = await getUser();
        if (savedUser != null && savedUser.nasabah != null) {
          // Update nasabah properties
          final updatedNasabah = NasabahModel(
            id: savedUser.nasabah!.id,
            userId: savedUser.nasabah!.userId,
            jenisKelamin: savedUser.nasabah!.jenisKelamin,
            usia: savedUser.nasabah!.usia,
            profesi: savedUser.nasabah!.profesi,
            tahuMemilahSampah: tahuMemilahSampah,
            motivasiMemilahSampah: motivasiMemilahSampah,
            nasabahBankSampah: nasabahBankSampah,
            kodeBankSampah: kodeBankSampah,
            frekuensiMemilahSampah: savedUser.nasabah!.frekuensiMemilahSampah,
            jenisSampahDikelola: savedUser.nasabah!.jenisSampahDikelola,
            profileCompletedAt: savedUser.nasabah!.profileCompletedAt,
            createdAt: savedUser.nasabah!.createdAt,
            updatedAt: savedUser.nasabah!.updatedAt,
          );

          // Update user model
          final updatedUser = UserModel(
            id: savedUser.id,
            name: savedUser.name,
            email: savedUser.email,
            phoneNumber: savedUser.phoneNumber,
            role: savedUser.role,
            createdAt: savedUser.createdAt,
            updatedAt: savedUser.updatedAt,
            profilePhotoUrl: savedUser.profilePhotoUrl,
            nasabah: updatedNasabah,
          );

          // Save updated user
          await saveUser(updatedUser);

          // Also update profile status if provided in response
          if (response['data'] != null &&
              response['data']['profile_status'] != null) {
            final profileStatus =
                ProfileStatusModel.fromJson(response['data']['profile_status']);
            await saveProfileStatus(profileStatus);
          }
        }

        return {
          'status': 'success',
          'message': 'Profil berhasil diperbarui',
          'data': response['data'],
        };
      } else {
        // Handling response error
        String errorMessage = 'Gagal memperbarui profil';
        if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('message')) {
          errorMessage = response['data']['message'];
        } else if (response.containsKey('statusMessage')) {
          errorMessage = response['statusMessage'];
        }

        return {
          'status': 'error',
          'message': errorMessage,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 2 Exception: $e");
      }

      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  /// Update Profile Step 3
  Future<Map<String, dynamic>> updateProfileStep3({
    required String frekuensiMemilahSampah,
    required String jenisSampahDikelola,
  }) async {
    try {
      if (kDebugMode) {
        print(
            "DEBUG - Update Profile Step 3 Request with data: frekuensi_memilah_sampah=$frekuensiMemilahSampah, jenis_sampah_dikelola=$jenisSampahDikelola");
      }

      // Panggil API dengan ApiService untuk update profil step 3
      final response = await _apiService.updateProfileStep3(
        frekuensiMemilahSampah: frekuensiMemilahSampah,
        jenisSampahDikelola: jenisSampahDikelola,
      );

      if (kDebugMode) {
        print("DEBUG - Update Profile Step 3 Response: $response");
      }

      if (response['success'] == true) {
        // Update local user data
        final savedUser = await getUser();
        if (savedUser != null && savedUser.nasabah != null) {
          // Get updated timestamps from response if available
          String? profileCompletedAt;
          String? updatedAt;

          if (response['data'] != null && response['data']['nasabah'] != null) {
            profileCompletedAt =
                response['data']['nasabah']['profile_completed_at'];
            updatedAt = response['data']['nasabah']['updated_at'];
          }

          // Update nasabah properties
          final updatedNasabah = NasabahModel(
            id: savedUser.nasabah!.id,
            userId: savedUser.nasabah!.userId,
            jenisKelamin: savedUser.nasabah!.jenisKelamin,
            usia: savedUser.nasabah!.usia,
            profesi: savedUser.nasabah!.profesi,
            tahuMemilahSampah: savedUser.nasabah!.tahuMemilahSampah,
            motivasiMemilahSampah: savedUser.nasabah!.motivasiMemilahSampah,
            nasabahBankSampah: savedUser.nasabah!.nasabahBankSampah,
            kodeBankSampah: savedUser.nasabah!.kodeBankSampah,
            frekuensiMemilahSampah: frekuensiMemilahSampah,
            jenisSampahDikelola: jenisSampahDikelola,
            profileCompletedAt:
                profileCompletedAt ?? savedUser.nasabah!.profileCompletedAt,
            createdAt: savedUser.nasabah!.createdAt,
            updatedAt: updatedAt ?? savedUser.nasabah!.updatedAt,
          );

          // Update user model
          final updatedUser = UserModel(
            id: savedUser.id,
            name: savedUser.name,
            email: savedUser.email,
            phoneNumber: savedUser.phoneNumber,
            role: savedUser.role,
            createdAt: savedUser.createdAt,
            updatedAt: savedUser.updatedAt,
            profilePhotoUrl: savedUser.profilePhotoUrl,
            nasabah: updatedNasabah,
          );

          // Save updated user
          await saveUser(updatedUser);

          // Also update profile status if provided in response
          if (response['data'] != null &&
              response['data']['profile_status'] != null) {
            final profileStatus =
                ProfileStatusModel.fromJson(response['data']['profile_status']);
            await saveProfileStatus(profileStatus);
          } else {
            // Step 3 completes the profile, so set the status to completed
            await saveProfileStatus(ProfileStatusModel(
              isCompleted: true,
              completionPercentage: 100,
              nextStep: '',
            ));
          }
        }

        return {
          'status': 'success',
          'message': 'Profil berhasil diperbarui',
          'data': response['data'],
        };
      } else {
        // Handling response error
        String errorMessage = 'Gagal memperbarui profil';
        if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('message')) {
          errorMessage = response['data']['message'];
        } else if (response.containsKey('statusMessage')) {
          errorMessage = response['statusMessage'];
        }

        return {
          'status': 'error',
          'message': errorMessage,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Update Profile Step 3 Exception: $e");
      }

      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  /// Get user dari shared preferences
  Future<UserModel?> getUser() async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Get user data string
      final userString = prefs.getString(_userKey);

      if (userString != null && userString.isNotEmpty) {
        // Parse user data
        final userJson = jsonDecode(userString);
        return UserModel.fromJson(userJson);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get User Exception: $e");
      }

      return null;
    }
  }

  /// Save user ke shared preferences
  Future<void> saveUser(UserModel user) async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Convert user to json string
      final userJson = user.toJson();
      final userString = jsonEncode(userJson);

      // Save user data
      await prefs.setString(_userKey, userString);

      if (kDebugMode) {
        print("DEBUG - User data saved successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Save User Exception: $e");
      }
    }
  }

  /// Get profile status dari shared preferences
  Future<ProfileStatusModel?> getProfileStatus() async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Get profile status string
      final profileStatusString = prefs.getString(_profileStatusKey);

      if (profileStatusString != null && profileStatusString.isNotEmpty) {
        // Parse profile status
        final profileStatusJson = jsonDecode(profileStatusString);
        return ProfileStatusModel.fromJson(profileStatusJson);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Get Profile Status Exception: $e");
      }

      return null;
    }
  }

  /// Save profile status ke shared preferences
  Future<void> saveProfileStatus(ProfileStatusModel profileStatus) async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Convert profile status to json string
      final profileStatusJson = profileStatus.toJson();
      final profileStatusString = jsonEncode(profileStatusJson);

      // Save profile status
      await prefs.setString(_profileStatusKey, profileStatusString);

      if (kDebugMode) {
        print("DEBUG - Profile status saved: $profileStatus");
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Save Profile Status Exception: $e");
      }
    }
  }

  /// Clear user data dari shared preferences
  Future<void> clearUserData() async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Remove user data
      await prefs.remove(_userKey);

      // Remove profile status
      await prefs.remove(_profileStatusKey);

      if (kDebugMode) {
        print("DEBUG - User data cleared successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Clear User Data Exception: $e");
      }
    }
  }

  /// Get token dari secure storage
  Future<String?> getToken() async {
    return await _httpClient.getToken();
  }
}
