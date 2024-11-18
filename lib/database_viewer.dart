import 'package:flutter/material.dart';
import 'database_helper.dart';

class DatabaseViewer extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Veritabanı Görüntüleyici')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getCourses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course['dersAd']),
                subtitle: Text('${course['DersKod']} - ${course['Sınıf']}'),
              );
            },
          );
        },
      ),
    );
  }
}
