import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careerwill/models/user.dart';
import 'package:careerwill/screens/auth/login/login.dart';
import 'package:careerwill/screens/home/component/result.dart';
import 'package:careerwill/screens/home/component/student_detail.dart';
import 'package:careerwill/screens/home/provider/home_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loggedInUser = userProvider.getLoginUsr();

    if (loggedInUser == null) {
      return const Scaffold(body: Center(child: Text("No user logged in.")));
    }

    final isTeacher = loggedInUser.role.toLowerCase() == "teacher";
    final isParent = loggedInUser.role.toLowerCase() == "parent";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        title: Text(
          "Hi, ${loggedInUser.name}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context, loggedInUser, userProvider),
      body: isTeacher
          ? _buildTeacherView()
          : isParent
          ? _buildParentView(loggedInUser.username)
          : const Center(child: Text("Unknown user role.")),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    User user,
    UserProvider userProvider,
  ) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade600],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.assessment_outlined, "View Results", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(studentName: user.name),
              ),
            );
          }),
          _buildDrawerItem(Icons.settings_outlined, "Settings", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings coming soon!")),
            );
          }),
          const Spacer(),
          _buildDrawerItem(
            Icons.logout,
            "Logout",
            () => _confirmLogout(context, userProvider),
            iconColor: Colors.red,
            textColor: Colors.red,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Logout Confirmation"),
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
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherView() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        if (homeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() => selectedStudentName = value);
                    Provider.of<HomeProvider>(
                      context,
                      listen: false,
                    ).searchStudents(value.trim());
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(14),
                    hintText: "Search student by name, phone or roll no",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedStudentName?.isNotEmpty == true)
                Expanded(child: _buildStudentList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentList() {
    final students = Provider.of<HomeProvider>(context).filteredStudents;

    if (students.isEmpty) {
      return const Center(child: Text("No students found."));
    }

    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final student = students[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDetailScreen(student: student),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: student.imageUrl?.url.isNotEmpty == true
                      ? NetworkImage(student.imageUrl!.url)
                      : null,
                  child: student.imageUrl?.url.isEmpty == true
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Roll No: ${student.rollNo}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParentView(String studentName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildStudentDetails(studentName),
    );
  }

  Widget _buildStudentDetails(String studentName) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final matches = homeProvider.filteredStudents
        .where((s) => s.name.toLowerCase().contains(studentName.toLowerCase()))
        .toList();

    if (matches.isEmpty) {
      return const Text('Student not found');
    }

    final student = matches.first;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Roll No: ${student.rollNo}"),
            Text("Phone: ${student.phone}"),
            Text("Address: ${student.address}"),
            const SizedBox(height: 12),
            const Text(
              "Kit Items:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...student.kit.map((item) => Text("• ${item.name}")).toList(),
          ],
        ),
      ),
    );
  }
}
