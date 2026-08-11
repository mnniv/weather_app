import 'dart:io'; // ضروري لمعرفة نظام التشغيل
import 'package:dio/dio.dart';
import '../Netwirking/api constant.dart';
import '../Netwirking/bBaseUr.dart';
import '../services/service_storage.dart';



class NotficationAPi {
  static var dio = Dio();

  static Future<String> notficationEnabled(String deviceToken,String accessToken) async {
    // 1. Check if we already sent this exact token
    final lastToken = await StorageService.getLastSentFcmToken();
    if (lastToken == deviceToken) {
      return "success"; // Return success without calling API
    }

    dio.options.headers["Authorization"] = "Bearer $accessToken";

    String deviceType = "unknown";
    if (Platform.isAndroid) {
      deviceType = "android";
    } else if (Platform.isIOS) {
      deviceType = "ios";
    }

    try {
      final response = await dio.post(
        "${BaseUrl.Baseurl+ApiConstant.registerdevice}",
        data: {
          "token": deviceToken,
          "device_type": deviceType,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "User-Agent": "Flutter-App",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 2. Save the token to cache upon success
        await StorageService.saveLastSentFcmToken(deviceToken);
        return "success";
      }
    } catch (e) {
    }
    return "error";
  }
}