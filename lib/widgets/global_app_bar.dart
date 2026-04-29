// File: lib/widgets/global_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final double height;
  final Widget? title;
  final bool enableShadow;
  final bool centerTitle;
  final double? titleSpacing;
  final bool showNotification;

  const GlobalAppBar({
    super.key,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.elevation = 0.5,
    this.actions,
    this.height = kToolbarHeight,
    this.title,
    this.enableShadow = true,
    this.centerTitle = true,
    this.titleSpacing,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = enableShadow
        ? Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
            ),
            child: _buildAppBarContent(context, elevation: 0),
          )
        : _buildAppBarContent(context, elevation: elevation);

    return PreferredSize(
      preferredSize: preferredSize,
      child: content,
    );
  }

  PreferredSizeWidget _buildAppBarContent(BuildContext context,
      {required double elevation}) {
    return AppBar(
      backgroundColor: enableShadow ? Colors.transparent : backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: false,
      leadingWidth: kToolbarHeight,
      title: title ?? _buildAppBarLogo(),
      leading: showBackButton
          ? IconButton(
              icon: SvgPicture.asset(
                'assets/icons/arrow_left_icon.svg',
                width: 24,
                height: 24,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: _buildActions(),
    );
  }

  List<Widget>? _buildActions() {
    List<Widget> currentActions = actions ?? [];

    if (showNotification) {
      currentActions.add(
        Padding(
          padding: EdgeInsets.only(right: 20.r),
          child: SvgPicture.asset(
            'assets/icons/bell_icon.svg',
            width: 18.r,
            height: 21.r,
          ),
        ),
      );
    }

    return currentActions.isNotEmpty ? currentActions : null;
  }

  Widget _buildAppBarLogo() {
    return SvgPicture.asset(
      'assets/images/appbar_logo.svg',
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
