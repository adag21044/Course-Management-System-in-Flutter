import 'package:flutter/material.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final loggedIn = await _dbHelper.login(username, password);

    if (loggedIn) {
      Navigator.pushNamed(context, '/secretaryPage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hatalı kullanıcı adı veya şifre')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
