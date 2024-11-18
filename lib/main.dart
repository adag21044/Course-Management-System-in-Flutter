import 'package:flutter/material.dart';
import 'login_page.dart';
import 'secretary_page.dart';
import 'database_viewer.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.printTables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/secretaryPage': (context) => SecretaryPage(),
        '/databaseViewer': (context) => DatabaseViewer(),
      },
    );
  }
}
