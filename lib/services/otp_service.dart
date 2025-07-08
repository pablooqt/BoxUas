import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPService {
  static String _otpCode = "";

  // Generate kode OTP 6 digit
  static String generateOTP() {
    final random = Random();
    _otpCode = (100000 + random.nextInt(899999)).toString();
    return _otpCode;
  }

  static String getOTP() => _otpCode;

  static Future<bool> sendOTP(String email) async {
  final serviceId = 'service_1xix1bg';
  final templateId = 'template_7t6kmek';
  final publicKey = '1vFGMnzz3RXHVGvYe';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
         'to_email': email,              
         'passcode': _otpCode,
         'time': '15 menit dari sekarang',
      }

    }),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  return response.statusCode == 200;
}

}
