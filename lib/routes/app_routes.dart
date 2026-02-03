/// Definisi konstanta semua routes di aplikasi ///
///
/// # NOTE:
/// Routes ini hanya mendefinisikan konstanta untuk nama-nama route.
/// Untuk menghubungkan route ke halaman (screen), perlu dibuat file app_pages.dart
/// yang menggunakan GetPage untuk menghubungkan route dengan widget dan binding.
///
/// Contoh penggunaan di app_pages.dart:
/// ```dart
/// GetPage(
///   name: Routes.login,
///   page: () => LoginScreen(),
///   binding: AuthBinding(),
/// )
/// ```
///
/// Contoh navigasi:
/// ```dart
/// Get.toNamed(Routes.login);
/// ```

class Routes {
  // Root & Splash
  static const String splash = '/';

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register'; // Pastikan rute ini sesuai
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordConfirmation =
      '/forgot-password-confirmation';
  static const String resetPassword = '/reset-password';
  static const String loginConfirm = '/login-confirm';

  // Onboarding
  static const String onboarding = '/onboarding';
  static const String insight = '/insight';

  // Main Routes
  static const String home = '/home';
  static const String profile = '/profile';

  // Profile
  static const String editProfile = '/profile/edit';
  static const String profileStep1 = '/profile/step1';
  static const String profileStep2 = '/profile/step2';
  static const String profileStep3 = '/profile/step3';
  static const String profileCompletion = '/profile/completion';

  // Bank Sampah
  static const String bankSampahList = '/bank-sampah/list';
  static const String bankSampahDetail = '/bank-sampah/detail';
  static const String bankSampahMember = '/bank-sampah/member';
  static const String bankSampahRegister = '/bank-sampah/register';

  // Jadwal Sampah
  static const String jadwalSampah = '/jadwal-sampah';
  static const String jadwalSampahAdd = '/jadwal-sampah/add';
  static const String jadwalSampahDetail = '/jadwal-sampah/detail';
  static const String jadwalPemilahan = '/jadwal-sampah/pemilahan';
  static const String jadwalSetoran = '/jadwal-sampah/setoran';
  static const String jadwalCalendar = '/jadwal-sampah/calendar';

  // Setoran Sampah
  static const String depositSelectBank = '/deposit/select-bank';
  static const String setoranSampah = '/setoran-sampah';
  static const String setoranSampahAdd = '/setoran-sampah/add';
  static const String setoranSampahDetail = '/setoran-sampah/detail';
  static const String setoranSuccess = '/setoran-sampah/success';
  static const String setoranHistory = '/setoran-sampah/history';
  static const String setoranOngoing = '/setoran-sampah/ongoing';
  static const String setoranPengajuan = '/setoran-sampah/pengajuan';
  static const String setoranTimeline = '/setoran-sampah/timeline';

  // Katalog Sampah
  static const String katalogSampah = '/katalog-sampah';
  static const String katalogByBankSampah = '/katalog-sampah/by-bank';
  static const String katalogBySubKategori = '/katalog-sampah/by-kategori';
  static const String katalogDetail = '/katalog-sampah/detail';

  // Edukasi
  static const String edukasi = '/edukasi';
  static const String edukasiModuls = '/edukasi/moduls';
  static const String edukasiModulDetail = '/edukasi/modul-detail';
  static const String edukasiVideo = '/edukasi/video';
  static const String edukasiArtikel = '/edukasi/artikel';
  static const String edukasiPoints = '/edukasi/points';

  // Detail Setoran
  static const String detailSetoran = '/detail-setoran';
  static const String detailSetoranBySetoran = '/detail-setoran/by-setoran';

  // Sub Kategori Sampah
  static const String subKategoriSampah = '/sub-kategori-sampah';
  static const String kategoriUtama = '/sub-kategori-sampah/kategori-utama';
  static const String subKategoriByBank = '/sub-kategori-sampah/by-bank';

  // Tarik Saldo
  static const String withdrawBalance = '/withdraw-balance';
  static const String withdrawBalanceForm = '/withdraw-balance/form';
  static const String withdrawSuccess = '/withdraw-balance/success';
}
