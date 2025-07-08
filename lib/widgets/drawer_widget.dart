import 'package:flutter/material.dart';
import '../session/session_manager.dart';
import '../model/user_model.dart';
import '../pages/login_page.dart';
import '../pages/my_reviews_page.dart';
import '../pages/main_navigation.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SessionManager.getUser();
    setState(() {
      _user = user;
    });
  }

  void _logout() {
    SessionManager.clearSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(_user!.username),
                  accountEmail: Text(_user!.email),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/default_profile.jpg'),
                  ),
                  decoration: const BoxDecoration(color: Color(0xFF437057)),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Beranda"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigation(initialIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.reviews),
                  title: const Text("My Reviews"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyReviewsPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: _logout,
                ),
              ],
            ),
    );
  }
}
