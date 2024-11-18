import 'package:flutter/material.dart';
import 'database_helper.dart';

class SecretaryPage extends StatefulWidget {
  @override
  _SecretaryPageState createState() => _SecretaryPageState();
}

class _SecretaryPageState extends State<SecretaryPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  // Fetch all courses from the database
  void _fetchCourses() async {
    final courses = await _dbHelper.getCourses();
    setState(() {
      _courses = courses;
    });
  }

  // Show dialog to add a new course
  Future<void> _showAddCourseDialog() async {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _codeController = TextEditingController();
    final TextEditingController _classController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Course Code'),
              ),
              TextField(
                controller: _classController,
                decoration: InputDecoration(labelText: 'Class'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _codeController.text.isNotEmpty &&
                    _classController.text.isNotEmpty) {
                  try {
                    await _dbHelper.addCourse(
                      _nameController.text.trim(),
                      _codeController.text.trim(),
                      _classController.text.trim(),
                    );
                    Navigator.pop(context); // Dialog'u kapat
                    _fetchCourses(); // Listeyi yenile
                  } catch (e) {
                    print("Error adding course: $e");
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Delete a course by ID
  void _deleteCourse(int id) async {
    try {
      await _dbHelper.deleteCourse(id);
      _fetchCourses(); // Refresh the courses list after deletion
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secretary Panel')),
      body: _courses.isEmpty
          ? Center(child: Text('No courses available'))
          : ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return ListTile(
                  title: Text(course['courseName']),
                  subtitle: Text('${course['courseCode']} - Class: ${course['courseClass']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCourse(course['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

        
