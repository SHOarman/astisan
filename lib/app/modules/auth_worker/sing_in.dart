import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/components/custom_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/constants/static/app_colors.dart';
import '../../core/constants/static/app_strings.dart';
import 'auth_controller_worker/auth_worker_controller.dart';

class SingIn extends GetView<AuthWorkerController> {
  const SingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40.0),
                _buildLoginForm(),
                const SizedBox(height: 32.0),
                _buildOrDivider(),
                const SizedBox(height: 40.0),
                _buildSignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack.tr,
          style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 28.0, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8.0),
        Text(
          AppStrings.signInSub.tr,
          style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: AppStrings.email.tr,
          hintText: 'example@mail.com',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || !GetUtils.isEmail(value)) ? 'Enter a valid email' : null,
        ),
        const SizedBox(height: 16.0),
        Obx(() => CustomTextField(
          labelText: AppStrings.password.tr,
          hintText: '***************',
          controller: controller.passwordController,
          obscureText: controller.obscurePassword.value,
          suffixIcon: IconButton(
            onPressed: () => controller.togglePasswordVisibility(),
            icon: Icon(controller.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Enter your password' : null,
        )),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (val) => controller.toggleRememberMe(val),
                  activeColor: AppColors.checkboxActive,
                )),
                Text(AppStrings.rememberMe.tr, style: GoogleFonts.poppins(fontSize: 14.0)),
              ],
            ),
            TextButton(
              onPressed: () => controller.navigateForgotPassword(),
              child: Text(AppStrings.forgotPassword.tr, style: GoogleFonts.poppins(color: AppColors.textColor)),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Obx(() => CustomButton(
          text: AppStrings.signIn.tr,
          isLoading: controller.isLoading.value,
          onPressed: () => controller.signIn(),
        )),
      ],
    );
  }

  Widget _buildOrDivider() {
    return Center(child: Text(AppStrings.or.tr, style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w500)));
  }

  Widget _buildSignUpPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '${AppStrings.dontHaveAccount.tr} ',
          style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 14.0),
          children: [
            TextSpan(
              text: AppStrings.signUp.tr,
              style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700),
              recognizer: TapGestureRecognizer()..onTap = controller.navigateToSignUp,
            ),
          ],
        ),
      ),
    );
  }
}