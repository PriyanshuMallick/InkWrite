import 'dart:io';

import 'package:inkwrite/env/env.dart';

class AppConst {
  static String ip = Env.ip;
  static final host = "http://$ip:${Env.port}";

  static Future<void> init() async {
    ip = await getPrivateIP();
  }
}

Future<String> getPrivateIP() async {
  // Look for the first interface with a non-loopback IPv4 address.
  for (NetworkInterface interface in await NetworkInterface.list()) {
    for (InternetAddress address in interface.addresses) {
      if (!address.isLoopback && address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }

  // If no non-loopback IPv4 address is found, return 'Unknown'.
  return 'Unknown';
}
