import 'package:flutter/foundation.dart';
import 'dart:io';

class Config {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    } else {
      // Windows/Linux/Mac Desktop: Gunakan IP Loopback IPv4 eksplisit
      // 'localhost' kadang resolve ke ::1 (IPv6) yang bisa bermasalah jika backend hanya IPv4
      return 'http://127.0.0.1:3000/api';
    }
  }
}
