import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? userName;
  String? password;

  Future<String> getUserNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? "";
  }

  Future<void> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
  }

  Future<bool> storeUserName(String userNames) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userName', userNames);
  }

  Future<bool> deleteUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(userName);
  }
}