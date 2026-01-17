// File: lib/widgets/global_app_bar.dart

import 'package:flutter/material.dart';

import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final double height;
  final Widget? title;

  const GlobalAppBar({
    super.key,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.elevation = 0.5,
    this.actions,
    this.height = kToolbarHeight,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: kToolbarHeight,
        title: title ?? _buildAppBarLogo(),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
      ),
    );
  }

  // Logo builder dengan fallback ke text jika gambar tidak ditemukan
  Widget _buildAppBarLogo() {
    return Image.asset(
      'assets/images/appbar_logo.png',
      height: 25,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback jika gambar tidak ditemukan
        return Text(
          'WANIGO',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
