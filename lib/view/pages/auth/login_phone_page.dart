/* import 'package:flutter/material.dart';
//import 'auth_repository.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final AuthRepository authRepository = AuthRepository();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  String verificationId = '';

  void _startPhoneAuth() async {
    try {
      await authRepository.signInWithPhoneNumber(phoneNumberController.text);
      setState(() {
        isOtpSent = true;
      });
      print('OTP sent to phone');
    } catch (error) {
      print('Phone authentication failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP: $error')),
      );
    }
  }

  void _verifyOtp() async {
    try {
      await authRepository.verifyOtp(verificationId, otpController.text);
      print('Phone authentication successful');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone authentication successful')),
      );
      // Optionally navigate to the next screen upon successful authentication
    } catch (error) {
      print('OTP verification failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _attemptAutoLogin();
  }

  void _attemptAutoLogin() async {
    try {
      await authRepository.autoLogin();
      print('Auto-login successful');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auto-login successful')),
      );
      // Optionally navigate to the next screen upon successful auto-login
    } catch (error) {
      print('Auto-login failed: $error');
      // Handle auto-login failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isOtpSent)
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            if (isOtpSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: 'OTP Code'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isOtpSent ? _verifyOtp : _startPhoneAuth,
              child: Text(isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
 */