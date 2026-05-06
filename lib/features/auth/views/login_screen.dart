import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/features/auth/controllers/login_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Menggunakan TextEditingController lokal untuk menghindari masalah disposed
  final TextEditingController _emailController = TextEditingController();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // AuthRepository untuk akses API
  final AuthRepository _authRepository = AuthRepository();
  final LoginController _loginController = Get.find<LoginController>();

  // Throttle untuk meminimalisir request berulang
  DateTime? _lastCheckTime;
  static const Duration _checkThrottleTime = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    // Cek argumen untuk pre-fill email jika ada
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('email')) {
      _emailController.text = args['email'];
    }

    // HAPUS default email untuk testing - tidak diperlukan lagi
    // if (_emailController.text.isEmpty && true) {
    //   _emailController.text = 'test@example.com';
    //   debugPrint('DEBUG - Email prefilled with test email for development');
    // }
  }

  @override
  void dispose() {
    // Dispose controller lokal saat widget di-dispose
    _emailController.dispose();
    super.dispose();
  }

  // Validasi email (sama dengan yang di LoginController)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Handle login dengan cara yang aman dari disposed controller
  void _handleLogin() async {
    // Hindari request beruntun terlalu cepat
    if (_lastCheckTime != null) {
      final difference = DateTime.now().difference(_lastCheckTime!);
      if (difference < _checkThrottleTime) {
        debugPrint(
            "DEBUG - Throttling email check request. Time since last request: ${difference.inMilliseconds}ms");
        return;
      }
    }
    _lastCheckTime = DateTime.now();

    // Reset error message
    _errorMessage.value = '';

    // Validasi email
    final email = _emailController.text.trim();
    final emailValidation = _validateEmail(email);

    if (emailValidation != null) {
      _errorMessage.value = emailValidation;
      Get.snackbar(
        'Perhatian',
        _errorMessage.value,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Tampilkan loading
    _isLoading.value = true;

    try {
      // Tambahkan timeout yang lebih panjang untuk mengatasi masalah koneksi
      final response = await _authRepository
          .checkEmail(email)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception(
            'Timeout: Server tidak merespon dalam waktu yang ditentukan');
      });

      // Debug log untuk melihat isi response
      debugPrint("DEBUG - Check Email Response: $response");

      // Verifikasi format response yang standar
      if (response.containsKey('status') && response['status'] == 'success') {
        // Ambil data dari respons API
        final data = response.containsKey('data') ? response['data'] : null;

        if (data != null) {
          // Periksa email_exists sesuai dengan spesifikasi API
          final bool emailExists =
              data.containsKey('email_exists') ? data['email_exists'] : false;

          final String? role =
              emailExists && data.containsKey('role') ? data['role'] : null;

          debugPrint("DEBUG - Email exists: $emailExists, Role: $role");

          if (emailExists) {
            // Periksa apakah role adalah nasabah
            if (role == 'nasabah') {
              // Email terdaftar dan role nasabah, navigasi ke login confirm
              debugPrint(
                  "DEBUG - Email terdaftar dengan role nasabah, navigasi ke login confirm");
              Get.toNamed(Routes.loginConfirm, arguments: email);
              return;
            } else {
              // Email terdaftar tapi bukan role nasabah
              _errorMessage.value =
                  "Email ini terdaftar dengan role '$role', bukan nasabah.";

              Get.snackbar(
                'Perhatian',
                _errorMessage.value,
                backgroundColor: Colors.orange[100],
                colorText: Colors.orange[900],
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 5),
              );
            }
          } else {
            // Email belum terdaftar, tampilkan dialog
            debugPrint("DEBUG - Email belum terdaftar, tampilkan dialog");
            _showEmailNotRegisteredDialog(email);
            return;
          }
        } else {
          // Data tidak ditemukan
          _errorMessage.value = 'Data tidak valid dari server';

          Get.snackbar(
            'Error',
            _errorMessage.value,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        // Status bukan success
        _errorMessage.value = response.containsKey('message')
            ? response['message']
            : 'Gagal memeriksa email';

        // Cek jika error terkait koneksi, tampilkan dialog koneksi
        if (_errorMessage.value.contains('koneksi') ||
            _errorMessage.value.contains('network') ||
            _errorMessage.value.contains('failed') ||
            _errorMessage.value.contains('timeout')) {
          _showConnectionErrorDialog(email);
          return;
        }

        Get.snackbar(
          'Error',
          _errorMessage.value,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint("DEBUG - General error checking email: $e");
      _errorMessage.value = e.toString();

      // Cek jika error terkait koneksi, tampilkan dialog koneksi
      if (_errorMessage.value.contains('koneksi') ||
          _errorMessage.value.contains('network') ||
          _errorMessage.value.contains('Failed host lookup') ||
          _errorMessage.value.contains('timeout')) {
        _showConnectionErrorDialog(email);
        return;
      }

      Get.snackbar(
        'Error',
        _errorMessage.value,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Dialog email belum terdaftar
  void _showEmailNotRegisteredDialog(String email) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email icon
              Icon(
                Icons.email,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),

              // Title text
              Text(
                "Email Belum Terdaftar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description text
              Text(
                "Email $email belum terdaftar di WANIGO. Ingin melanjutkan pendaftaran?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Continue registration button
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.toNamed(Routes.register, arguments: email);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjutkan Pendaftaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Back button
              OutlinedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade300),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // User harus pilih salah satu tombol
    );
  }

  // Dialog untuk error koneksi
  void _showConnectionErrorDialog(String email) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Network error icon
              Icon(
                Icons.signal_wifi_off,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 16),

              // Title text
              Text(
                "Gagal Terhubung",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description text
              Text(
                "Tidak dapat terhubung ke server. Silakan periksa koneksi internet atau gunakan mode offline.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Try again button
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  _handleLogin(); // Try again
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Opsi untuk langsung menuju login confirm
              OutlinedButton(
                onPressed: () {
                  Get.back(); // Close dialog

                  // Langsung ke login confirm
                  Get.toNamed(Routes.loginConfirm, arguments: email);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade300),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjutkan Dengan Email Ini',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // User harus pilih salah satu tombol
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone mockups image
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Image.asset(
                  'assets/images/login_ads.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 80,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Content section below image
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading with fire emoji on one line
                    const Text(
                      'Berani Kelola Sampah, Mulai dari Sekarang 🔥',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email input
                    const Text(
                      'Alamat Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan alamat email anda disini',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        // Clear error message when user types
                        if (_errorMessage.value.isNotEmpty) {
                          _errorMessage.value = '';
                        }
                      },
                    ),

                    const SizedBox(height: 32),

                    // Login Button dengan Obx
                    Obx(() => ElevatedButton(
                          onPressed: _isLoading.value
                              ? null // Disable button saat loading
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Masuk Aplikasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 1,
                            color: AppColors.gray600.withOpacity(0.3),
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GlobalText(
                              text: 'atau masuk cepat',
                              variant: TextVariant.smallMedium,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: 'assets/icons/google_icon.svg',
                              isLoading: _loginController.isLoading.value,
                              onTap: () => _loginController.signInWithGoogle(),
                            ),
                            const SizedBox(width: 24),
                            _buildSocialButton(
                              icon: 'assets/icons/facebook_icon.svg',
                              onTap: () => _loginController.signInWithFacebook(),
                            ),
                          ],
                        )),

                    const SizedBox(height: 16),

                    // Error message
                    Obx(() => _errorMessage.value.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _errorMessage.value,
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),

                    // Privacy policy text
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                                text: 'Dengan melanjutkan, Anda menyetujui '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: const TextStyle(
                                color: Color(0xFF1976D2),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle privacy policy tap
                                },
                            ),
                            const TextSpan(text: ' yang berlaku di WANIGO!.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                ),
        ),
      ),
    );
  }
}
