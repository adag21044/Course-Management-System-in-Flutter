import 'package:flutter/material.dart';
import 'login_page.dart';
import 'secretary_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      },
    );
  }
}
