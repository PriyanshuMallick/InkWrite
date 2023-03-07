import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PORT', obfuscate: true)
  static final port = _Env.port;
  @EnviedField(varName: 'IP', obfuscate: true)
  static final ip = _Env.ip;
}

// Run This Command After Updating This File
// flutter pub run build_runner build --delete-conflicting-outputs