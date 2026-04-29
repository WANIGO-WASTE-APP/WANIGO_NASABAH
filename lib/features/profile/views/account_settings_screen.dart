import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/features/profile/controllers/account_settings_controller.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

class AccountSettingsScreen extends GetView<AccountSettingsController> {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(
        showBackButton: true,
        backgroundColor: Colors.white,
        elevation: 0,
        enableShadow: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              _buildPhotoSection(),

              const SizedBox(height: 40),

              // Name Field
              _buildFieldLabel("Nama Profil"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.nameController,
                hint: "Masukkan nama profil",
              ),
              const SizedBox(height: 8),
              _buildHelperText(
                  "Pastikan nama profil kamu tidak melebihi 3 kata ya"),

              const SizedBox(height: 24),

              // Phone Field
              _buildFieldLabel("Nomor Telepon"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.phoneController,
                hint: "Masukkan nomor telepon",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              _buildHelperText("Nomor telepon sudah terverifikasi"),

              const SizedBox(height: 24),

              // Email Field
              _buildFieldLabel("Alamat Email"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.emailController,
                hint: "Masukkan alamat email",
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),

              const SizedBox(height: 60),

              // Save Button
              Obx(() => GlobalButton(
                    text: "Simpan Perubahan",
                    variant: ButtonVariant.large,
                    onPressed: controller.updateProfile,
                    isLoading: controller.isLoading.value,
                  )),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.changeProfilePhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFDE047),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlobalText(
            text: "Sentuh untuk mengganti Foto Profile",
            variant: TextVariant.smallMedium,
            color: AppColors.gray600,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return GlobalText(
      text: label,
      variant: TextVariant.mediumSemiBold,
      color: AppColors.gray900,
    );
  }

  Widget _buildHelperText(String text) {
    return GlobalText(
      text: text,
      variant: TextVariant.smallRegular,
      color: AppColors.gray400,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.gray900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue500, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }
}
