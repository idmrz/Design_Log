import 'package:flutter/material.dart';
import 'package:login_system/DesignPages/letter_page.dart';
import 'package:login_system/DesignPages/pdesign_page.dart';
import 'package:login_system/DesignList/wd_list_page.dart';
import 'package:login_system/DesignList/pd_list_page.dart';
import 'package:login_system/DesignList/lt_list_page.dart';
import 'login_widget.dart';
import 'token_manager.dart';
import 'user_info_page.dart';
import 'user_info_display_page.dart';
import 'user_model.dart';
import 'login_info_display_page.dart';
import 'DesignPages/wd_page.dart';

class HomePage extends StatelessWidget {
  final TokenManager tokenManager = TokenManager();
  final UserModel _userModel = UserModel();

  HomePage({super.key});

   Future<void> _logout(BuildContext context) async {
    // Show confirmation dialog
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismiss dialog and return false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Dismiss dialog and return true
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      // Delete the token
      await tokenManager.deleteToken();
      String userName = await _userModel.getUserNames();
      await _userModel.deleteUserName(userName);
      print(userName);

      // Navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: LoginWidget(
              onLogin: (username, password) {},
              onSuccess: () {},
            ),
          ),
        ),
      );
    }
  }

  void _redirectToUserInfo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoPage()));
  }

  void _redirectToUserDisplay(BuildContext context) async {
    String userName = await _userModel.getUserNames();
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoDisplayPage(userName: userName)));
  }

  void _redirectToLoginDisplay(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginInfoDisplayPage()));
  }

  void redirectToDesignPage(BuildContext context, String page) {
    Widget newPage;
    switch (page) {
      case 'WD':
        newPage = const WDPage();
        break;
      case 'PD':
        newPage = const PdesignPage();
        break;
      case 'Letter':
        newPage = const LetterPage();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => newPage));
  }

  void redirectToLatestWDPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const WDListPage()));
  }

  void redirectToLatestPDPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PDListPage()));
  }

  void redirectToLatestLTPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LTListPage()));
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTapDown: (TapDownDetails details) {
                // Açılır menüyü göstermek için kullanıcının simgeye tıkladığı yeri alıyoruz
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'userInfo',
                      child: const Text('User Info'),
                      onTap: () => Future.delayed(Duration.zero, () => _redirectToUserInfo(context)),
                    ),
                    PopupMenuItem(
                      value: 'userDisplay',
                      child: const Text('User Display'),
                      onTap: () => Future.delayed(Duration.zero, () => _redirectToUserDisplay(context)),
                    ),
                    PopupMenuItem(
                      value: 'loginDisplay',
                      child: const Text('Login Display'),
                      onTap: () => Future.delayed(Duration.zero, () => _redirectToLoginDisplay(context)),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: const Text('Logout'),
                      onTap: () => Future.delayed(Duration.zero, () => _logout(context)),
                    ),
                  ],
                );
              },
              child: const Row(
                children: [
                   Icon(Icons.person, color: Color.fromARGB(255, 148, 129, 216)),
                  SizedBox(width: 20),
                  // const Text('login',
                  //   style: TextStyle(color: Color.fromARGB(255, 151, 98, 98), fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: const HomeContent(), // Yeni içerik bileşeni burada çağırılıyor
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal.shade100,
        automaticallyImplyLeading: false,
      ),
      body: const HomeContent(),
    );
  }

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F4F8), Color(0xFFDEE2E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Welcome to the Dashboard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34495E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WDListPage())),
                          icon: const Icon(Icons.document_scanner, color: Color(0xFF5DA3FA)),
                          label: const Text('WD'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF5DA3FA),
                            side: const BorderSide(color: Color(0xFF5DA3FA)),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PDListPage())),
                          icon: const Icon(Icons.design_services, color: Color(0xFF9B59B6)),
                          label: const Text('PDesign'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF9B59B6),
                            side: const BorderSide(color: Color(0xFF9B59B6)),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LTListPage())),
                          icon: const Icon(Icons.mail, color: Color(0xFF2ECC71)),
                          label: const Text('Letter'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2ECC71),
                            side: const BorderSide(color: Color(0xFF2ECC71)),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
