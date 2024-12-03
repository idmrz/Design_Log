import 'package:flutter/material.dart';
import '/update_password.dart';
import '/user_model.dart';

class LoginInfoDisplayPage extends StatefulWidget {
  const LoginInfoDisplayPage({super.key});

  @override
   LoginInfoDisplayPageState createState() => LoginInfoDisplayPageState();
}

class LoginInfoDisplayPageState extends State<LoginInfoDisplayPage> {
  final UserModel _userModel = UserModel();

  @override
  void initState() {
    super.initState();
    _fetchLoginInfo();
  }

  Future<void> _fetchLoginInfo() async {
    final username = await _userModel.getUserNames();

    setState(() {
      _userModel.userName = username;
    });
  }

  void _navigateToUpdatePasswordPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Info Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Username'),
              subtitle: Text(
                _userModel.userName ?? '',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const ListTile(
              title: Text('Password'),
              subtitle: Text(
                '********',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToUpdatePasswordPage(context),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}