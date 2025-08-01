import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:careerwill/screens/home/provider/home_provider.dart';
import 'package:careerwill/screens/home/component/search_bar.dart';
import 'package:careerwill/screens/home/component/empty_student_placeholder.dart';
import 'package:careerwill/screens/home/component/student_card.dart';

class TeacherView extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedStudentName;
  final Function(String) onSearchChanged;

  const TeacherView({
    required this.searchController,
    required this.selectedStudentName,
    required this.onSearchChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        if (homeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SearchBar(controller: searchController, onChanged: onSearchChanged),
            if (selectedStudentName?.isNotEmpty == true)
              Expanded(child: StudentList(students: homeProvider.filteredStudents))
            else
              const Expanded(child: EmptyStudentPlaceholder()),
          ],
        );
      },
    );
  }
}
