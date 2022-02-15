import 'package:flutter/services.dart';

class PlatformRepository {
  PlatformRepository._();

  static const platform = const MethodChannel('flutter.native/helper');
  static final PlatformRepository repo = PlatformRepository._();

  Future<String> saveFile(String source, String destination, String dbType) async {
    try {
      final String result = await platform.invokeMethod(
          "saveFile",
          <String, String>{
            "source": source,
            "destination": destination,
            "dbType": dbType
          });
      print(result);
    } on PlatformException catch (e) {
      print(e);
    }
    return Future(() => 'GOOD');
  }
}