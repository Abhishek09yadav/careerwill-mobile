import 'dart:developer';

import 'package:careerwill/models/user.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:careerwill/utitlity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  DioService dio = DioService();
  final box = GetStorage();

  Future<String> login(LoginData data) async {
    try {
      Map<String, dynamic> loginData = {
        "email": data.name.toLowerCase(),
        "password": data.password,
      };

      final res = await dio.postItems(
        endpointUrl: "/auth/login",
        data: loginData,
      );

      if (res.statusCode == 200) {
        final json = res.data;

        if (json["token"] != null && json["user"] != null) {
          String token = json["token"];
          final userJson = json["user"] as Map<String, dynamic>;

          // Add token into user JSON
          userJson["token"] = token;

          // Create User object
          User user = User.fromJson(userJson);

          await saveLoginInfo(user);

          log("Login Successful → token: $token");
          return token;
        } else {
          throw Exception(json["message"] ?? "Login failed.");
        }
      } else {
        throw Exception("Server error: ${res.statusCode}");
      }
    } catch (e) {
      log("Error in login $e");
      rethrow;
    }
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
  }

  User? getLoginUsr() {
  Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
  if (userJson == null) return null;
  return User.fromJson(userJson);
}


}
