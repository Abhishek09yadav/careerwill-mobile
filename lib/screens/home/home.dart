import 'dart:developer';

import 'package:careerwill/models/kit.dart';
import 'package:careerwill/models/student.dart';
import 'package:careerwill/screens/auth/login/login.dart';
import 'package:careerwill/screens/home/component/result.dart';
import 'package:careerwill/screens/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/models/user.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedStudentName;

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchAllStudents();
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
      appBar: AppBar(title: Text("Welcome ${loggedInUser.username}")),
      drawer: _buildDrawer(context, loggedInUser, userProvider),
      body: isTeacher
          ? _buildTeacherView(context)
          : isParent
          ? _buildParentView(context, loggedInUser.username)
          : const Center(child: Text("Unknown user role.")),
    );
  }

  /// Drawer widget
  Widget _buildDrawer(
    BuildContext context,
    User user,
    UserProvider userProvider,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.username ?? 'User'),
            accountEmail: Text(user.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Results'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResultScreen(studentName: user.username ?? 'Your Child'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await userProvider.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherView(BuildContext context) {
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
              log("searched for --> $value");
              setState(() {
                selectedStudentName = value;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<HomeProvider>(
                  context,
                  listen: false,
                ).searchStudents(value);
              });
            },
          ),
          const SizedBox(height: 20),
          if (selectedStudentName != null)
            Expanded(
              child: _buildStudentDetails(context, selectedStudentName!),
            ),
        ],
      ),
    );
  }

  Widget _buildParentView(BuildContext context, String studentName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildStudentDetails(context, studentName),
    );
  }

  Widget _buildStudentDetails(BuildContext context, String studentName) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final matches = homeProvider.filteredStudents
        .where((s) => s.name.toLowerCase().contains(studentName.toLowerCase()))
        .toList();

    if (matches.isEmpty) {
      return const Text('Student not found');
    }

    final student = matches.first;

    if (student == null) return Text('Student not found');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Student: ${student.name}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
