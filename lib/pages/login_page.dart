import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import 'main_navigation.dart';
import 'register_page.dart';
import '../model/user_model.dart';
import '../services/otp_service.dart';
import 'otp_verification_page.dart';
import '../session/session_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = "";

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final user = await DBHelper().getUser(username, password);
    if (user != null) {
      SessionManager.setUser(user);

      OTPService.generateOTP();
      final sent = await OTPService.sendOTP(user.email);

      if (sent) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationPage(email: user.email),
          ),
        );
      } else {
        setState(() {
          _error = "Gagal mengirim email verifikasi.";
        });
      }
    } else {
      setState(() {
        _error = "Username atau Password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: const Color(0xFF437057),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3DE61).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(Icons.person, size: 100, color: Color(0xFF2F5249)),
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF97B067),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: const Text("Belum punya akun? Daftar"),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
