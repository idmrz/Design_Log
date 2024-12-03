import 'package:flutter/material.dart';
import 'home.dart';
import 'login_widget.dart';
import 'service.dart';
import 'token_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Service service = Service();
  Function(String, String) get loginUser => service.loginUser;
  final TokenManager _tokenManager = TokenManager();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String>(
        future: _tokenManager.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking the token
            return const CircularProgressIndicator();
          } else {
            String token = snapshot.data ?? '';
            if (token.isNotEmpty) {
              //print(token);
              // Token exists, navigate to the home page
              return HomePage();
            } else {
              // Token doesn't exist, show the login page
              return Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: LoginWidget(
                        onLogin: loginUser,
                        onSuccess: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
