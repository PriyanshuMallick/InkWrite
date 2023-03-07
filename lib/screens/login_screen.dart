import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkwrite/screens/home_screen.dart';

import '../authentication/auth_repository.dart';
import '../themes/app_colors.dart';
import '../themes/app_icons.dart';
import '../themes/app_styles.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final error = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (error.error != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(error.error!),
        ),
      );
      return;
    }

    ref.read(userProvider.notifier).update((state) => error.data);
    navigator.push(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: AppIcons.googleLogo,
          label: Text(
            'Sign In with Google',
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
