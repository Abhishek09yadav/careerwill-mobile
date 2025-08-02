import 'package:flutter/material.dart';
import 'package:careerwill/models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text(student.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            student.imageUrl.url.isNotEmpty
                ? Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(student.imageUrl.url),
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white70,
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow("Roll No", student.rollNo.toString()),
                    const Divider(),
                    _buildInfoRow("Phone", student.phone),
                    const Divider(),
                    _buildInfoRow("Address", student.address),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kit Items",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (student.kit.isNotEmpty)
                        ...student.kit.map(
                          (kit) => ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.blue,
                            ),
                            title: Text(kit.name),
                            subtitle: Text(kit.description),
                          ),
                        )
                      else
                        const Text("No kit items assigned."),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ResultScreen(),
                  //   ),
                  // );
                },
                child: const Text(
                  "View Result",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const ResultScreen(),
                //     ),
                //   );
                },
                child: const Text(
                  "View Attendance",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ResultScreen(),
                  //   ),
                  // );
                },
                child: const Text(
                  "View Fee details",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
