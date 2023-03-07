import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkwrite/authentication/auth_repository.dart';
import 'package:inkwrite/models/ErrorModel.dart';
import 'package:inkwrite/screens/home_screen.dart';
import 'package:inkwrite/screens/login_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? _errorModel;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    _errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (_errorModel != null && _errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => _errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp(
      title: 'Docs Clone',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
