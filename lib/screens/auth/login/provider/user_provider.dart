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
        "name": data.name.toLowerCase(),
        "password": data.password,
      };
      final res = await dio.postItems(
        endpointUrl: "/auth/login",
        data: loginData,
      );
      if (res.statusCode == 200) {
        final json = res.data;
        if (json["token"] != null) {
          String token = json["token"];
          log("Token: $token");

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
    User? userLogged = User.fromJson(userJson ?? {});
    return userLogged;
  }
}
