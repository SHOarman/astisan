import 'package:flutter/material.dart';
import '../constants/static/app_colors.dart';

class PhotoThumbnailTile extends StatelessWidget {
  final Widget child; // Use Widget because I'll use icons or placeholders

  const PhotoThumbnailTile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      margin: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(child: child),
    );
  }
}

