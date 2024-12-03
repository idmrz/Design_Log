import 'service.dart';
import 'login_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  //create the service class object
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Username'),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Username',
              ),
            ),
            //for some space bwtween fields
            const SizedBox(
              height: 10,
            ),
            const Text('Password'),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Password',
              ),
              obscureText: true, // Set this to true to hide the password
            ),
            //for some space bwtween fields
            const SizedBox(
              height: 10,
            ),
            const Text('Role'),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Role',
              ),
            ),
            //for some space bwtween fields
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            //for some space bwtween fields
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                service.saveUser(
                  userNameController.text,
                  passwordController.text,
                  roleController.text,
                );
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWidget(
                      onLogin: (username, password) {},
                      onSuccess: () {},
                    ),
                  ),
                );
              },
              child: const Text(
                'I have already an account',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
