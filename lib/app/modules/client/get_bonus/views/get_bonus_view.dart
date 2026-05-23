import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/get_bonus_controller.dart';

class GetBonusView extends GetView<GetBonusController> {
  const GetBonusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.referAndEarn.tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.referAndEarn.tr,
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              AppStrings.referAndEarnDesc.tr,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: AppColors.greyText,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48.0),
            Text(
              AppStrings.sharePromoCode.tr,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          controller.isLoading.value ? '...' : (controller.referralCode.value.isEmpty ? AppStrings.na.tr : controller.referralCode.value),
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                            letterSpacing: 0.5,
                          ),
                        )),
                        Row(
                          children: [
                            Container(
                              width: 1,
                              height: 32,
                              color: const Color(0xFFD1D5DB),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_outlined, color: AppColors.textColor, size: 20),
                              onPressed: controller.copyReferralCode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: controller.inviteFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7CBD),
                      minimumSize: const Size(double.infinity, 56.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.invite.tr,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text(
              AppStrings.referralHistory.tr,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.referralHistory.isEmpty) {
                return Text(
                  AppStrings.noReferralsYet.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    color: AppColors.greyText,
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.referralHistory.length,
                itemBuilder: (context, index) {
                  final ref = controller.referralHistory[index];
                  final name = ref['referred_name'] ?? ref['referred_email'] ?? AppStrings.unknown.tr;
                  final bool bonusPaid = ref['bonus_paid'] == true;
                  final amount = ref['bonus_amount'] ?? '0';
                  
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withAlpha(20),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      bonusPaid ? AppStrings.bonusPaid.tr : AppStrings.pending.tr,
                      style: GoogleFonts.poppins(
                        color: bonusPaid ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      "\$$amount",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
