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

  void _fetchCourses() async {
    final courses = await _dbHelper.getCourses();
    setState(() {
      _courses = courses;
    });
  }

  void _addCourse() async {
    await _dbHelper.addCourse('OOP', 'BİL 201', '2. Sınıf');
    _fetchCourses();
  }

  void _deleteCourse(int id) async {
    await _dbHelper.deleteCourse(id);
    _fetchCourses();
  }

  void _updateCourse(int id) async {
    await _dbHelper.updateCourse(id, 'Güncel OOP', 'BİL 202');
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sekreter Paneli')),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return ListTile(
            title: Text(course['dersAd']),
            subtitle: Text('${course['DersKod']} - ${course['Sınıf']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateCourse(course['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCourse(course['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourse,
        child: Icon(Icons.add),
      ),
    );
  }
}
