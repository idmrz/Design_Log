import 'package:flutter/material.dart';
import '/register.dart';
import '/user_model.dart';
import './service.dart';
import 'home.dart';
import 'token_manager.dart';

class LoginWidget extends StatefulWidget {
  final Function(String, String) onLogin;
  final Function onSuccess;

  const LoginWidget({super.key, required this.onLogin, required this.onSuccess});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final Service service = Service();
  final TokenManager tokenManager = TokenManager();
  final UserModel _userModel = UserModel();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String username = usernameController.text;
              String password = passwordController.text;
              // Call the loginUser method from the Service class
              var response = await service.loginUser(username, password);
              if (response.statusCode == 200) {
                // Login successful
                widget.onLogin(username, password);
                widget.onSuccess();
                String token = await tokenManager.getToken();
                print(token);
                String userName = await _userModel.getUserNames();
                print(userName);
                // Invoke the callback function
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              } else {
                // Handle login error
                setState(() {
                  errorMessage = 'Invalid username or password';
                });
              }
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Navigate to the register page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text("Don't have an account?"),
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}