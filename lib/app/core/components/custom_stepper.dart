import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/static/app_colors.dart';
import '../constants/static/app_strings.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;

  const CustomStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      AppStrings.dateTime.tr,
      AppStrings.address.tr,
      AppStrings.notes.tr,
      AppStrings.imageUpload.tr,
      AppStrings.confirm.tr,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final stepNumber = index + 1;
          final isCompleted = currentStep > stepNumber;
          final isActive = currentStep == stepNumber;

          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted || isActive ? AppColors.stepperActive : AppColors.stepperInactive,
                        ),
                        child: isCompleted
                            ? Icon(Icons.check, color: AppColors.white, size: 16.0)
                            : Center(
                                child: Text(
                                  '$stepNumber',
                                  style: GoogleFonts.poppins(
                                    color: isCompleted || isActive ? AppColors.white : AppColors.greyText,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        steps[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isCompleted || isActive ? AppColors.stepperActive : AppColors.greyText,
                          fontSize: 10.0,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0),
                      height: 2.0,
                      color: isCompleted ? AppColors.stepperActive : AppColors.stepperInactive,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

