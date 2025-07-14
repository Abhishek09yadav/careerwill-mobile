import 'package:careerwill/screens/auth/login/login.dart';
import 'package:careerwill/screens/home/component/result.dart';
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
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User? loggedInUser = userProvider.getLoginUsr();

    if (loggedInUser == null) {
      return const Scaffold(
          body: Center(child: Text("No user logged in.")));
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
      BuildContext context, User user, UserProvider userProvider) {
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
                  builder: (context) => ResultScreen(
                      studentName: user.username ?? 'Your Child'),
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
              MaterialPageRoute(builder: (context) => const LoginPage()),
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
              setState(() {
                selectedStudentName = value;
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
    // Dummy data - replace with API data later
    double presentPercentage = 78.5;
    int presentDays = 17;
    int absentDays = 5;
    double totalFees = 50000;
    double paidFees = 30000;
    double remainingFees = totalFees - paidFees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Student: $studentName",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        _attendanceCard(presentPercentage, presentDays, absentDays),
        const SizedBox(height: 16),
        _feesCard(totalFees, paidFees, remainingFees),
        const SizedBox(height: 16),
        _resultCard(context, studentName),
      ],
    );
  }

  Widget _attendanceCard(
      double presentPercentage, int presentDays, int absentDays) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: presentPercentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "${presentPercentage.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attendance",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Present Days: $presentDays"),
                  Text("Absent Days: $absentDays"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feesCard(double total, double paid, double remaining) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text("Total Fees: ₹${total.toStringAsFixed(2)}"),
              Text("Fees Paid: ₹${paid.toStringAsFixed(2)}"),
              Text("Remaining Fees: ₹${remaining.toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultCard(BuildContext context, String studentName) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(studentName: studentName),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.assessment, size: 40, color: Colors.blue),
              const SizedBox(width: 16),
              const Text(
                "View Results",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
