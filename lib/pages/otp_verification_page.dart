import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../services/otp_service.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  OTPVerificationPage({required this.email});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  String _error = "";

  void _verify() {
    if (_otpController.text == OTPService.getOTP()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(initialIndex: 0), 
        ),
      );
    } else {
      setState(() {
        _error = "Kode OTP salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Kode OTP telah dikirim ke ${widget.email}"),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: "Masukkan Kode OTP",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verify,
              child: Text("Verifikasi"),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(_error, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
