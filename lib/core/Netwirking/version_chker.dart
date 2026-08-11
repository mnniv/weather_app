import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/Theming/Colors/colors.dart';
import '../../../core/Theming/Fonts/TextStyleManger.dart';
import 'api constant.dart';
import 'bBaseUr.dart';

class VersionChecker {
  static Future<void> checkVersion() async {
    try {
      // 1️⃣ نسخة التطبيق الحالية
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // 2️⃣ جلب بيانات النسخ من API
      final response = await http.get(Uri.parse("${BaseUrl.Baseurl + ApiConstant.Leatest}"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        String oldestAllowed = data["oldestAllowed"];
        String latestVersion = data["current"];

        // 3️⃣ منطق التحديث
        if (_isOldVersion(currentVersion, oldestAllowed)) {
          // تحديث إجباري
          _showUpdateDialog(force: true, latest: latestVersion);
        } else if (_isOldVersion(currentVersion, latestVersion)) {
          // تحديث اختياري
          _showUpdateDialog(force: false, latest: latestVersion);
        }
      }
    } catch (e) {
      print("Error checking version: $e");
    }
  }

  static bool _isOldVersion(String current, String latest) {
    List<int> c = current.split('.').map(int.parse).toList();
    List<int> l = latest.split('.').map(int.parse).toList();
    for (int i = 0; i < l.length; i++) {
      if (c[i] < l[i]) return true;
      if (c[i] > l[i]) return false;
    }
    return false;
  }

  static void _showUpdateDialog({required bool force, required String latest}) {
    Future.microtask(() {
     
    });

  }
}
