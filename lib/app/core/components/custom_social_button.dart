import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/static/app_colors.dart';

class CustomSocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const CustomSocialButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: const BoxDecoration(
          color: AppColors.socialButtonBg,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          iconPath,
          width: 30.0,
          height: 30.0,
          placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

