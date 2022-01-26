
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBiometrics {
  static const MethodChannel _channel = MethodChannel('flutter_biometrics');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get availableBiometrics async {
    final String? bio = await _channel.invokeMethod('getPlatformBiometrics');
    return bio;
  }
}
