import 'dart:developer';

import 'package:careerwill/models/student.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final DioService _dio = DioService();

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Student> get filteredStudents => _filteredStudents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Student?>> fetchAllStudents() async {
    log(">>> fetchAllStudents called");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: "/student/get-all-students",
        queryParameters: {"page": 1, "limit": 1000},
      );
      log("status code ---> ${response.statusCode}");
      log(">>> response.data = ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data["students"];
        _allStudents = [];
        for (var json in jsonList) {
          try {
            _allStudents.add(Student.fromJson(json));
            log("We are here");
          } catch (e) {
            log("❌ Failed to parse student: $e\nData: $json");
          }
        }

        _filteredStudents = _allStudents;
        log("all students ---->   $_allStudents");
      } else {
        _errorMessage = response.data["message"] ?? "Failed to load students.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    return _allStudents;
  }

  void searchStudents(String query) {
    if (query.isEmpty) {
      _filteredStudents = _allStudents;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredStudents = _allStudents.where((student) {
        final rollMatch =
            int.tryParse(query) != null && student.rollNo == int.parse(query);
        return student.name.toLowerCase().contains(lowerQuery) ||
            student.id.toLowerCase() == lowerQuery ||
            student.phone.contains(query) ||
            rollMatch;
      }).toList();
    }

    log("Filtered students: ${_filteredStudents.map((e) => e.name).toList()}");
    notifyListeners();
  }

  Future<Student?> fetchStudentByRollNo(int rollNo) async {
    if (_allStudents.isEmpty) await fetchAllStudents();

    try {
      return _allStudents.firstWhere((s) => s.rollNo == rollNo);
    } catch (_) {
      return null;
    }
  }

  Future<Student?> fetchStudentByName(String name) async {
    if (_allStudents.isEmpty) await fetchAllStudents();

    try {
      return _allStudents.firstWhere(
        (s) => s.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Student?> fetchStudentByPhone(String phone) async {
    if (_allStudents.isEmpty) await fetchAllStudents();

    try {
      return _allStudents.firstWhere((s) => s.phone == phone);
    } catch (_) {
      return null;
    }
  }
}
