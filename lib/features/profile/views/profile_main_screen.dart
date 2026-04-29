import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/features/profile/controllers/profile_controller.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

class ProfileMainScreen extends GetView<ProfileController> {
  const ProfileMainScreen({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          // Header / User Section
          _buildUserHeader(),
          
          const SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFF1F1F1)),
          
          // Menu List
          _buildMenuSection(),
          
          const Spacer(),
          
          // Logout Button
          _buildLogoutButton(),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Profile Avatar with Yellow Background (as in design)
          Obx(() {
            final photoUrl = controller.profilePhotoUrl;
            return Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFDE047), // Yellow color from design
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            );
          }),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => GlobalText(
                  text: controller.userName,
                  variant: TextVariant.h4,
                  color: AppColors.gray900,
                )),
                const SizedBox(height: 4),
                GlobalText(
                  text: controller.userRole,
                  variant: TextVariant.mediumRegular,
                  color: AppColors.gray600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          iconPath: Icons.person_outline,
          title: "Pengaturan Akun",
          onTap: controller.goToAccountSettings,
        ),
        _buildMenuItem(
          iconPath: Icons.phone_android_outlined,
          title: "Pengaturan Aplikasi",
          onTap: controller.goToAppSettings,
        ),
        _buildMenuItem(
          iconPath: Icons.help_outline,
          title: "Pusat Bantuan",
          onTap: controller.goToHelpCenter,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              iconPath,
              color: AppColors.blue600,
              size: 28,
            ),
          ),
          title: GlobalText(
            text: title,
            variant: TextVariant.mediumMedium,
            color: AppColors.gray900,
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.gray400,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
        const Divider(
          thickness: 1,
          color: Color(0xFFF1F1F1),
          height: 1,
          indent: 24,
          endIndent: 24,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() => GlobalButton(
        text: "Keluar Akun",
        variant: ButtonVariant.large,
        onPressed: controller.logout,
        isLoading: controller.isLoading.value,
      )),
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
