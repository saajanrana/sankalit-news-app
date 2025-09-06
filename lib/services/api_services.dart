import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Sankalit/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final apiUrl = dotenv.env['API_URL'];
final accessToken = dotenv.env['API_KEY'];

// 👇 Global ScaffoldMessenger key
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ApiServices {
  /// ✅ POST request
  static dynamic post({
    required String endpoint,
    Map<String, dynamic> queryParameters = const {},
  }) async {
    try {
      bool internetConnectionStatus =
          await InternetConnection().hasInternetAccess;
      if (!internetConnectionStatus) {
        return {"noInternet": true};
      }

      Uri uri = Uri.parse(apiUrl! + endpoint);
      final body = json.encode(queryParameters);

      final response = await http
          .post(
            uri,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        // ✅ Show success SnackBar
        _showSnackBar(
          'Request successful!',
          AppTheme.primaryColor,
          AppTheme.lightBackgroundColor,
        );
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        // handleUnauthorized();
        return;
      } else {
        _showSnackBar(
          'Something went wrong, please restart the application and try again.',
          AppTheme.primaryColor,
          AppTheme.lightBackgroundColor,
        );
      }
    } on TimeoutException catch (_) {
      _showSnackBar(
        'Something went wrong, please try again after some time.',
        Colors.red,
        Colors.white,
      );
    } catch (e) {
      print("error in post:::$e");
    }
  }

  /// ✅ GET request
  static dynamic get({
    required String endpoint,
    dynamic queryParameters,
  }) async {
    try {
      bool internetConnectionStatus =
          await InternetConnection().hasInternetAccess;
      if (!internetConnectionStatus) {
        return {"noInternet": true};
      }

      late final uri;
      if (queryParameters != null) {
        uri = Uri.parse(apiUrl! + endpoint, queryParameters);
      } else {
        uri = Uri.parse(apiUrl! + endpoint);
      }

      final response = await http
          .get(
            uri,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        // handleUnauthorized();
        return;
      } else {
        _showSnackBar(
          'Something went wrong, please restart the application and try again.',
          Colors.red,
          Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      _showSnackBar(
        'Something went wrong, please try again after some time.',
        Colors.red,
        Colors.white,
      );
    } catch (e) {
      print("error in get:::$e");
    }
  }

  /// ✅ Utility function for SnackBars
static void _showSnackBar(String message, Color bgColor, Color textColor) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 12.sp,
          color: textColor,
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20), // 👈 adds space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // optional rounded look
      ),
    ),
  );
}

}
