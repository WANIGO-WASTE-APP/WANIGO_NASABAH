class Endpoints {
  // Endpoint Autentikasi
  static const String checkEmail = '/api/check-email';
  static const String register = '/api/register';
  static const String login = '/api/login';
  static const String logout = '/api/logout';
  static const String forgotPassword = '/api/forgot-password';
  static const String resetPassword = '/api/reset-password';

  // Endpoint Profil
  static const String profile = '/api/profile';
  static const String updateProfile = '/api/update-profile';
  static const String updatePassword = '/api/update-password';
  static const String profileStatus = '/api/profile-status';

  // Endpoint Profil Nasabah
  static const String nasabahProfile = '/api/nasabah/profile';
  static const String nasabahProfileStep1 = '/api/nasabah/profile/step1';
  static const String nasabahProfileStep2 = '/api/nasabah/profile/step2';
  static const String nasabahProfileStep3 = '/api/nasabah/profile/step3';
  static const String nasabahBankSampahDetail =
      '/api/nasabah/bank-sampah'; // + /{id}

  // Bank Sampah Endpoints
  static const String bankSampahDetail = '/api/bank-sampah'; // + /{id}
  static const String bankSampahJamOperasional =
      '/api/bank-sampah'; // + /{id}/jam-operasional
  static const String bankSampahLokasi = '/api/bank-sampah'; // + /{id}/lokasi
  static const String bankSampahKontak = '/api/bank-sampah'; // + /{id}/kontak

  // Member Bank Sampah Endpoints
  static const String memberBankSampah = '/api/member-bank-sampah';
  static const String checkNasabah =
      '/api/check-nasabah'; // + /{bank_sampah_id}
  static const String registerMember = '/api/register-member';
  static const String removeMember =
      '/api/remove-member'; // + /{bank_sampah_id}

  // Edukasi Endpoints
  static const String edukasiModuls = '/api/edukasi/moduls';
  static const String edukasiModulDetail = '/api/edukasi/modul'; // + /{id}
  static const String edukasiVideoDetail = '/api/edukasi/video'; // + /{id}
  static const String edukasiVideoProgress =
      '/api/edukasi/video'; // + /{id}/progress
  static const String edukasiArtikelDetail = '/api/edukasi/artikel'; // + /{id}
  static const String edukasiArtikelProgress =
      '/api/edukasi/artikel'; // + /{id}/progress
  static const String edukasiPoints = '/api/edukasi/points';

  // Jadwal Sampah Endpoints
  static const String jadwalSampah = '/api/jadwal-sampah';
  static const String jadwalByTanggal = '/api/jadwal-by-tanggal';
  static const String jadwalPemilahan = '/api/jadwal-pemilahan';
  static const String jadwalSetoran = '/api/jadwal-setoran';
  static const String jadwalMarkCompleted = '/api/jadwal-mark-completed';

  // Setoran Sampah Endpoints
  static const String setoranSampah = '/api/setoran-sampah';
  static const String setoranHistory = '/api/setoran-history';
  static const String setoranOngoing = '/api/setoran-ongoing';
  static const String setoranStatistics = '/api/setoran-statistics';
  static const String setoranDashboardStats = '/api/dashboard-stats';
  static const String setoranPengajuan = '/api/setoran-pengajuan';
  static const String setoranTimeline =
      '/api/setoran-sampah'; // + /{id}/timeline
  static const String setoranCancel = '/api/setoran-sampah'; // + /{id}/cancel

  // Detail Setoran Endpoints
  static const String detailSetoran = '/api/detail-setoran';
  static const String detailSetoranBySetoran = '/api/detail-by-setoran';
  static const String detailSetoranItemDetail =
      '/api/detail-setoran'; // + /{id}/detail
  static const String detailSetoranBulkUpdate =
      '/api/detail-setoran-bulk-update';

  // Katalog Sampah Endpoints
  static const String katalogByBankSampah = '/api/katalog-by-bank-sampah';
  static const String katalogDetail = '/api/katalog'; // + /{id}
  static const String katalogSearch = '/api/katalog-search';
  static const String katalogForSetoran = '/api/katalog-for-setoran';
  static const String katalogBySubKategori = '/api/katalog-by-sub-kategori';

  // Sub Kategori Sampah Endpoints
  static const String subKategoriKategoriUtama = '/api/kategori-utama';
  static const String subKategoriByBankSampah =
      '/api/sub-kategori-by-bank-sampah';
  static const String subKategoriKatalog = '/api/sub-kategori-katalog';
  static const String subKategoriForSetoran = '/api/sub-kategori-for-setoran';
  static const String subKategoriByKategori = '/api/sub-kategori-by-kategori';
}
