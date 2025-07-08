import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uts/widgets/drawer_widget.dart';
import '../session/session_manager.dart';
import '../model/user_model.dart';
import '../pages/login_page.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _user = SessionManager.getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      drawer: DrawerWidget(), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F5249),
        title: const Text("Profile", style: TextStyle(color: Color(0xFFE3DE61))),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _user!.profilePicture != null
                  ? FileImage(File(_user!.profilePicture!))
                  : const AssetImage("assets/default_profile.png") as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              _user!.username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F5249),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _user!.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF97B067)),
              title: const Text("Ubah Profil (Belum aktif)"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Fitur belum tersedia"),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                SessionManager.clearSession();
                Navigator.pushReplacement(
                 context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
