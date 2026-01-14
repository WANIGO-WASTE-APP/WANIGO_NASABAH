import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart'
    hide GlobalAppBar; // Hide GlobalAppBar from wanigo_ui
import 'package:wanigo_nasabah/features/profile/controllers/profile_step_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart'; // Import the custom GlobalAppBar
import 'package:flutter/foundation.dart';

// Step 1: Data Pribadi (Jenis Kelamin, Usia, Profesi)
class ProfileStep1Screen extends GetView<ProfileStepController> {
  const ProfileStep1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure ProfileStepController is properly initialized
    final ProfileStepController controller = Get.find<ProfileStepController>();

    if (kDebugMode) {
      print("DEBUG - Building ProfileStep1Screen");
    }

    return ProfileStepBase(
      currentStep: 1,
      totalSteps: 3,
      progress: 0.33, // 33% progress
      children: [
        // 1. Jenis kelamin
        _buildQuestion("1. Jenis kelamin Anda?"),
        const SizedBox(height: 16),

        // Gender Options
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Laki-laki",
                    variant: ButtonVariant.large,
                    style: controller.jenisKelamin.value == "Laki-laki"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setJenisKelamin("Laki-laki"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Perempuan",
                    variant: ButtonVariant.large,
                    style: controller.jenisKelamin.value == "Perempuan"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setJenisKelamin("Perempuan"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. Usia
        _buildQuestion("2. Berapakah usia anda saat ini?"),
        const SizedBox(height: 16),

        // Age Options (2 rows of 2)
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Dibawah 18 tahun",
                    variant: ButtonVariant.large,
                    style: controller.usia.value == "Dibawah 18 tahun"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setUsia("Dibawah 18 tahun"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "18 hingga 34 tahun",
                    variant: ButtonVariant.large,
                    style: controller.usia.value == "18 hingga 34 tahun"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setUsia("18 hingga 34 tahun"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "34 hingga 54 tahun",
                    variant: ButtonVariant.large,
                    style: controller.usia.value == "34 hingga 54 tahun"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setUsia("34 hingga 54 tahun"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Di atas 54 tahun",
                    variant: ButtonVariant.large,
                    style: controller.usia.value == "Di atas 54 tahun"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller.setUsia("Di atas 54 tahun"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 3. Profesi
        _buildQuestion("3. Apa nama profesi anda saat ini?"),
        const SizedBox(height: 16),

        // PERBAIKAN: Ganti GlobalTextField dengan TextField standar
        // untuk mengatasi masalah hanya bisa menampilkan 1 huruf
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller.profesiController,
            decoration: InputDecoration(
              hintText: "Masukkan nama profesi anda saat ini",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
            onChanged: (value) => controller.setProfesi(value),
          ),
        ),

        const SizedBox(height: 24),

        // Next Button
        Obx(() {
          final isValid = controller.isStep1Valid();
          if (kDebugMode) {
            print("DEBUG - Button check: isStep1Valid() = $isValid");
          }
          return GlobalButton(
            text: "Lanjutkan",
            variant: ButtonVariant.large,
            onPressed: () => controller.saveStep1AndNext(),
          );
        }),
      ],
    );
  }

  Widget _buildQuestion(String text) {
    return GlobalText(
      text: text,
      variant: TextVariant.mediumSemiBold,
      color: AppColors.gray600,
    );
  }
}

// Step 2: Data Tambahan (Tahu Memilah, Motivasi, Status Bank Sampah)
class ProfileStep2Screen extends GetView<ProfileStepController> {
  const ProfileStep2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure ProfileStepController is properly initialized
    final ProfileStepController controller = Get.find<ProfileStepController>();

    if (kDebugMode) {
      print("DEBUG - Building ProfileStep2Screen");
    }

    return ProfileStepBase(
      currentStep: 2,
      totalSteps: 3,
      progress: 0.66, // 66% progress
      children: [
        // 1. Apakah tahu cara memilah sampah
        _buildQuestion("1. Apakah anda tahu cara memilah sampah?"),
        const SizedBox(height: 16),

        // Knowledge Options
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Sudah tahu",
                    variant: ButtonVariant.large,
                    style: controller.tahuMemilahSampah.value == "Sudah tahu"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setTahuMemilahSampah("Sudah tahu"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Belum tahu",
                    variant: ButtonVariant.large,
                    style: controller.tahuMemilahSampah.value == "Belum tahu"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setTahuMemilahSampah("Belum tahu"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. Motivasi
        _buildQuestion("2. Apa motivasi anda memilah sampah?"),
        const SizedBox(height: 16),

        // Motivation Options
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Menghasilkan uang",
                    variant: ButtonVariant.large,
                    style: controller.motivasiMemilahSampah.value ==
                            "Menghasilkan uang"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller
                        .setMotivasiMemilahSampah("Menghasilkan uang"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Menjaga lingkungan",
                    variant: ButtonVariant.large,
                    style: controller.motivasiMemilahSampah.value ==
                            "Menjaga lingkungan"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () => controller
                        .setMotivasiMemilahSampah("Menjaga lingkungan"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 3. Status nasabah bank sampah
        _buildQuestion(
            "3. Apakah sudah menjadi nasabah bank sampah mitra WANIGO sebelumnya?"),
        const SizedBox(height: 16),

        // Bank Sampah Status Options
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Iya, Sudah",
                    variant: ButtonVariant.large,
                    style: controller.nasabahBankSampah.value == "Iya, sudah"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setNasabahBankSampah("Iya, sudah"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Tidak, Belum",
                    variant: ButtonVariant.large,
                    style: controller.nasabahBankSampah.value == "Tidak, belum"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setNasabahBankSampah("Tidak, belum"),
                  )),
            ),
          ],
        ),

        // Kode Bank Sampah (Conditional)
        Obx(() => controller.nasabahBankSampah.value == "Iya, sudah"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  GlobalText(
                    text: "Kode bank sampah mitra WANIGO",
                    variant: TextVariant.mediumSemiBold,
                    color: AppColors.gray600,
                  ),
                  const SizedBox(height: 16),
                  // PERBAIKAN: Ganti dengan TextField standar
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller.kodeBankSampahController,
                      decoration: InputDecoration(
                        hintText: "Masukkan kode bank sampah mitra WANIGO",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => controller.setKodeBankSampah(value),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink()),

        const SizedBox(height: 24),

        // Next Button
        GlobalButton(
          text: "Lanjutkan",
          variant: ButtonVariant.large,
          onPressed: () => controller.saveStep2AndNext(),
        ),
      ],
    );
  }

  Widget _buildQuestion(String text) {
    return GlobalText(
      text: text,
      variant: TextVariant.mediumSemiBold,
      color: AppColors.gray600,
    );
  }
}

// Step 3: Data Lainnya (Frekuensi, Jenis Sampah)
class ProfileStep3Screen extends GetView<ProfileStepController> {
  const ProfileStep3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure ProfileStepController is properly initialized
    final ProfileStepController controller = Get.find<ProfileStepController>();

    if (kDebugMode) {
      print("DEBUG - Building ProfileStep3Screen");
    }

    return ProfileStepBase(
      currentStep: 3,
      totalSteps: 3,
      progress: 1.0, // 100% progress
      children: [
        // 1. Frekuensi memilah sampah
        _buildQuestion("1. Seberapa sering Anda memilah sampah?"),
        const SizedBox(height: 16),

        // Frequency Options (2 rows of 2)
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Setiap hari",
                    variant: ButtonVariant.large,
                    style:
                        controller.frekuensiMemilahSampah.value == "Setiap hari"
                            ? ButtonStyle.primary
                            : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setFrekuensiMemilahSampah("Setiap hari"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Setiap minggu",
                    variant: ButtonVariant.large,
                    style: controller.frekuensiMemilahSampah.value ==
                            "Setiap minggu"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setFrekuensiMemilahSampah("Setiap minggu"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Setiap bulan",
                    variant: ButtonVariant.large,
                    style: controller.frekuensiMemilahSampah.value ==
                            "Setiap bulan"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setFrekuensiMemilahSampah("Setiap bulan"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Sangat jarang",
                    variant: ButtonVariant.large,
                    style: controller.frekuensiMemilahSampah.value ==
                            "Sangat jarang"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setFrekuensiMemilahSampah("Sangat jarang"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. Jenis sampah
        _buildQuestion("2. Jenis sampah yang paling sering dikelola?"),
        const SizedBox(height: 16),

        // Waste Type Options (3 rows of 2)
        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Plastik",
                    variant: ButtonVariant.large,
                    style: controller.jenisSampahDikelola.value == "Plastik"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Plastik"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Kertas/kardus",
                    variant: ButtonVariant.large,
                    style:
                        controller.jenisSampahDikelola.value == "Kertas/Kardus"
                            ? ButtonStyle.primary
                            : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Kertas/Kardus"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Kaca / Logam",
                    variant: ButtonVariant.large,
                    style: controller.jenisSampahDikelola.value == "Kaca/Logam"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Kaca/Logam"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Elektronik",
                    variant: ButtonVariant.large,
                    style: controller.jenisSampahDikelola.value == "Elektronik"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Elektronik"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Organik",
                    variant: ButtonVariant.large,
                    style: controller.jenisSampahDikelola.value == "Organik"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Organik"),
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => GlobalButton(
                    text: "Lainnya",
                    variant: ButtonVariant.large,
                    style: controller.jenisSampahDikelola.value == "Lainnya"
                        ? ButtonStyle.primary
                        : ButtonStyle.secondary,
                    onPressed: () =>
                        controller.setJenisSampahDikelola("Lainnya"),
                  )),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Submit Button
        GlobalButton(
          text: "Lanjutkan",
          variant: ButtonVariant.large,
          onPressed: () => controller.saveStep3AndFinish(),
        ),

        // Padding bawah untuk memberikan ruang
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildQuestion(String text) {
    return GlobalText(
      text: text,
      variant: TextVariant.mediumSemiBold,
      color: AppColors.gray600,
    );
  }
}

// Completion Screen - PERBAIKAN UTAMA
class ProfileCompletionScreen extends GetView<ProfileStepController> {
  const ProfileCompletionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure ProfileStepController is properly initialized
    final ProfileStepController controller = Get.find<ProfileStepController>();

    if (kDebugMode) {
      print("DEBUG - Building ProfileCompletionScreen");
    }

    return BaseWidgetContainer(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        showBackButton: false, // PERUBAHAN: Hilangkan tombol back
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // PERUBAHAN UTAMA: Gunakan Column bukan Stack untuk mencegah scroll di halaman completion
      body: Column(
        children: [
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // PENTING: Tengahkan konten
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Party icon
                  Image.asset(
                    'assets/images/party_icon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        print("DEBUG - Error loading party icon: $error");
                      }
                      return Icon(
                        Icons.celebration,
                        size: 80,
                        color: AppColors.blue500,
                      );
                    },
                  ),

                  const SizedBox(height: 29),

                  // Heading
                  GlobalText(
                    text: 'Selamat! Profil Insight\nAnda Telah Selesai',
                    variant: TextVariant.h3,
                    textAlign: TextAlign.center,
                    color: AppColors.gray600,
                  ),

                  const SizedBox(height: 29),

                  // Insight Result
                  GlobalText(
                    text: 'Hasil Insight Diperoleh:',
                    variant: TextVariant.mediumSemiBold,
                    textAlign: TextAlign.center,
                    color: AppColors.gray900,
                  ),

                  const SizedBox(height: 12),

                  // Result card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue100,
                    ),
                    child: GlobalText(
                      text:
                          'Terima kasih telah menyelesaikan pertanyaan di WANIGO! Insight. Kami melihat Anda memiliki semangat tinggi dalam memilah sampah. Jangan khawatir, WANIGO! menyediakan berbagai fitur untuk membantu perjalanan Anda!',
                      variant: TextVariant.smallMedium,
                      textAlign: TextAlign.center,
                      color: AppColors.gray900,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Start button - PERBAIKAN UTAMA di sini untuk mengatasi masalah navigasi
                  GlobalButton(
                    text: 'Mulai Jelajahi Fitur WANIGO!',
                    variant: ButtonVariant.large,
                    onPressed: () {
                      if (kDebugMode) {
                        print("DEBUG - Home button clicked directly");
                      }
                      // PERUBAHAN: Gunakan direct navigation untuk menghindari masalah controller
                      Get.offAllNamed(Routes.home);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom decoration - DI LUAR Expanded untuk memastikan selalu di bawah
          // dengan ukuran yang konsisten (tidak dipaksa meregang untuk mengisi ruang kosong)
          Image.asset(
            'assets/images/bg_main_bottom.png',
            width: double.infinity,
            height: 100, // PERUBAHAN: Tetapkan tinggi yang konsisten
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print("DEBUG - Error loading bottom image: $error");
              }
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.blue100.withOpacity(0.3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Base widget for all profile step screens - PERUBAHAN UTAMA pada struktur layout
class ProfileStepBase extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progress;
  final List<Widget> children;

  const ProfileStepBase({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.progress,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // PERUBAHAN UTAMA: Menggunakan Column dengan Expanded untuk
      // memastikan gambar background selalu di bagian bawah
      body: Column(
        children: [
          // Content utama dengan scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1082.25),
                        color: AppColors.blue200,
                      ),
                      child: Stack(
                        children: [
                          // Progress bar
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1082.25),
                                color: AppColors.blue600,
                              ),
                            ),
                          ),

                          // White dot at the end of progress
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity:
                                  progress > 0.95 ? 1 : 0, // Only show at 100%
                              child: Center(
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.blue600,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // White dot for current progress
                          Positioned(
                            left: (MediaQuery.of(context).size.width - 40) *
                                    progress -
                                8,
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: progress < 0.95 ? 1 : 0, // Hide at 100%
                              child: Center(
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.blue600,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Step Title
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "📋 Daftar Pertanyaan ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray600,
                            ),
                          ),
                          TextSpan(
                            text: "$currentStep dari $totalSteps",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form content
                    ...children,
                  ],
                ),
              ),
            ),
          ),

          // PERUBAHAN UTAMA: Bottom decoration di luar area scroll
          // DENGAN TINGGI TETAP untuk memastikan konsistensi tampilan
          Image.asset(
            'assets/images/bg_main_bottom.png',
            width: double.infinity,
            height: 100, // Tetapkan tinggi yang konsisten
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print("DEBUG - Error loading bottom image: $error");
              }
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.blue100.withOpacity(0.3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
