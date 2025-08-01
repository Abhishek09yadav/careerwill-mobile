import 'package:careerwill/screens/home/component/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:careerwill/screens/home/component/home_drawer.dart';
import 'package:careerwill/screens/home/component/teacher_view.dart';
import 'package:careerwill/screens/home/component/parent_view.dart';
import 'package:careerwill/screens/home/provider/home_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).getLoginUsr();
      debugPrint("Logged-in User Students: ${user?.students}");
      Provider.of<HomeProvider>(context, listen: false).fetchAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loggedInUser = userProvider.getLoginUsr();

    if (loggedInUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in.")),
      );
    }

    final isTeacher = loggedInUser.role.toLowerCase() == "teacher";
    final isParent = loggedInUser.role.toLowerCase() == "parent";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildHomeAppBar(loggedInUser.username),
      drawer: buildHomeDrawer(context, loggedInUser, userProvider),
      body: isTeacher
          ? TeacherView(
              searchController: searchController,
              selectedStudentName: selectedStudentName,
              onSearchChanged: (value) {
                setState(() => selectedStudentName = value);
                Provider.of<HomeProvider>(context, listen: false)
                    .searchStudents(value.trim());
              },
            )
          : isParent
              ? const ParentView()
              : const Center(child: Text("Unknown user role.")),
    );
  }
}
