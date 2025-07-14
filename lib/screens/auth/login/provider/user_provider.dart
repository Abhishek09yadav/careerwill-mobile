import 'dart:developer';

import 'package:careerwill/models/user.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:careerwill/utitlity/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  DioService dio = DioService();
  final box = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  Future<bool> login({required String email, password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.postItems(
        endpointUrl: "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        _message = response.data["message"];
        var userJson = response.data["user"];
        User loginUser = User.fromJson(userJson);

        await saveLoginInfo(loginUser);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _message = "Login failed: ${response.data}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
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

  Future<void> logout() async {
    await box.erase();
    _message = null;
    _isLoading = false;
    notifyListeners();

    log("User logged out");
  }
}
