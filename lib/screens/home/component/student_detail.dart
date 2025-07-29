import 'package:flutter/material.dart';
import 'package:careerwill/models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (student.imageUrl?.url.isNotEmpty == true)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(student.imageUrl!.url),
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

            Card(
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
