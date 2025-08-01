import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/models/user.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';

class ResultScreen extends StatefulWidget {
  final String? studentName;

  const ResultScreen({super.key, this.studentName});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController searchController = TextEditingController();

  String? selectedStudentName;

  @override
  void initState() {
    super.initState();

    // If coming from Parent Home Screen, widget.studentName will be provided
    if (widget.studentName != null) {
      selectedStudentName = widget.studentName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User? loggedInUser = userProvider.getLoginUsr();

    if (loggedInUser == null) {
      return const Scaffold(body: Center(child: Text("No user logged in.")));
    }

    bool isTeacher = loggedInUser.role.toLowerCase() == "teacher";
    bool isParent = loggedInUser.role.toLowerCase() == "parent";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTeacher
              ? "Search Student Results"
              : "Results for ${selectedStudentName ?? 'Student'}",
        ),
      ),
      body: isTeacher
          ? _buildTeacherView()
          : _buildResultDetails(selectedStudentName ?? loggedInUser.username),
    );
  }

  Widget _buildTeacherView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Search Student Name",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                selectedStudentName = value;
              });
            },
          ),
          const SizedBox(height: 20),
          if (selectedStudentName != null)
            Expanded(child: _buildResultDetails(selectedStudentName!)),
        ],
      ),
    );
  }

  Widget _buildResultDetails(String studentName) {
    // Dummy result data — replace with real API data later
    final results = [
      {"subject": "Maths", "marks": 78},
      {"subject": "Science", "marks": 85},
      {"subject": "English", "marks": 92},
    ];

    return results.isEmpty
        ? Center(
            child: Text(
              "No results found for $studentName",
              style: const TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.blue),
                  title: Text(result["subject"] as String),
                  trailing: Text(
                    "${result["marks"]} / 100",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
