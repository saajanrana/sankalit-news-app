import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Sankalit/core/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final apiUrl = dotenv.env['API_URL'];
final accessToken = dotenv.env['API_KEY'];

class ApiServices {
  static dynamic post({required String endpoint, Map<String, dynamic> queryParameters = const {}}) async {
    try {
      print("API POST Request: $apiUrl$endpoint" + "accessToken$accessToken");

      bool internetConnectionStatus = await InternetConnection().hasInternetAccess;
      if (!internetConnectionStatus) {
        return {"noInternet": true};
      }
      Uri uri = Uri.parse(apiUrl! + endpoint);
      final body = json.encode(queryParameters);
      // final body = queryParameters;
      final response = await http
          .post(uri,
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer $accessToken',
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: body)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        // handleUnauthorized();
        return;
      } else {
        Fluttertoast.cancel();
        // Detect orientation
        Fluttertoast.showToast(
          msg: 'Something went wrong, please restart the application and try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.primaryColor,
          textColor: AppTheme.lightBackgroundColor,
          fontSize: 12.sp,
        );
      }
    } on TimeoutException catch (_) {
      Fluttertoast.cancel();
      // Detect orientation
      Fluttertoast.showToast(
        msg: 'Something went wrong, please try again after some time.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.primaryColor,
        textColor: AppTheme.lightBackgroundColor,
        fontSize: 12.sp,
      );
    } catch (e) {
      print("error in post:::$e");
    }
  }

  static dynamic get({
    required String endpoint,
    dynamic queryParameters,
  }) async {
    try {
      bool internetConnectionStatus = await InternetConnection().hasInternetAccess;
      if (!internetConnectionStatus) {
        return {"noInternet": true};
      }
      late final uri;

      if (queryParameters != null) {
        uri = Uri.parse(apiUrl! + endpoint, queryParameters);
      } else {
        uri = Uri.parse(apiUrl! + endpoint);
      }
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: '0',
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        // handleUnauthorized();
        return;
      } else {
        Fluttertoast.cancel();
        // Detect orientation

        Fluttertoast.showToast(
          msg: 'Something went wrong, please restart the application and try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.primaryColor,
          textColor: AppTheme.lightBackgroundColor,
          fontSize: 12.sp,
        );
      }
    } on TimeoutException catch (_) {
      Fluttertoast.cancel();
      // Detect orientation
      Fluttertoast.showToast(
        msg: 'Something went wrong, please try again after some time.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.primaryColor,
        textColor: AppTheme.lightBackgroundColor,
        fontSize: 12.sp,
      );
    } catch (e) {
      print("error in post:::$e");
    }
  }
}
