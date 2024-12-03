import 'package:flutter/material.dart';
import '/token_manager.dart';
import '/user_model.dart';
import '/service.dart';
import '/login_widget.dart';

class UserInfoDisplayPage extends StatefulWidget {
  final String userName;

  UserInfoDisplayPage({required this.userName});

  @override
  _UserInfoDisplayPageState createState() => _UserInfoDisplayPageState();
}

class _UserInfoDisplayPageState extends State<UserInfoDisplayPage> {
  final Service service = Service();
  UserInfoDto? userInfo;
  final TokenManager _tokenManager = TokenManager();
  final UserModel _userModel = UserModel();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      var fetchedUserInfo = await service.getUserInfo(widget.userName);
      setState(() {
        userInfo = fetchedUserInfo;
      });
    } catch (e) {
      print('Failed to fetch user info: $e');
    }
  }

  Future<void> _deleteUser() async {
    try {
      await service.deleteUser(widget.userName);
      await _tokenManager.deleteToken();
      String userName = await _userModel.getUserNames();
      await _userModel.deleteUserName(userName);
      print(userName);
      // Redirect to the login page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginWidget(
                  onLogin: (username, password) {}, onSuccess: () {})));
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info Display'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: userInfo != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/avatar_image.jpg'),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('First Name'),
                      subtitle: Text(
                        userInfo!.firstName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Last Name'),
                      subtitle: Text(
                        userInfo!.lastName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Birth Date'),
                      subtitle: Text(
                        userInfo!.birthDate,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Gender'),
                      subtitle: Text(
                        userInfo!.gender,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Age'),
                      subtitle: Text(
                        userInfo!.age.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Are you sure you want to delete this user?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _deleteUser();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Delete User'),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}