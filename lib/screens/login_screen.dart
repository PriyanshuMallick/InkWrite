import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/app_colors.dart';
import '../themes/app_icons.dart';
import '../themes/app_styles.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => print("Google"),
          icon: AppIcons.googleLogo,
          label: Text(
            "Sign In with Google",
            style: AppStyles.normal,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.signInBtnBG,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}
