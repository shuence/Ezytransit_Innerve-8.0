import 'package:ezytransit_innerve/screens/Home/home_screen.dart';
import 'package:ezytransit_innerve/screens/auth/signup_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  void sendOTP() async {
    String mobileNumber = mobileNumberController.text.trim();
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$mobileNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() {
          isOtpSent = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle OTP sent
        setState(() {
          isOtpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }

  void verifyOTP() async {
    String otp = otpController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: '', // Set the verification ID received during codeSent callback
      smsCode: otp,
    );
    try {
      await _auth.signInWithCredential(credential);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } catch (e) {
      print('Error verifying OTP: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid OTP'),
            content: const Text('Please enter a valid OTP.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 800,
          padding: const EdgeInsets.symmetric(vertical: 100),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/ezytranzit.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Dela Gothic One',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter the following details for sign in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 42),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 66, vertical: 13),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0),
                  borderRadius: BorderRadius.circular(5),
                  border: const Border(
                    left: BorderSide(color: Color(0x3D09BD62)),
                    top: BorderSide(color: Color(0x3D09BD62)),
                    right: BorderSide(color: Color(0x3D09BD62)),
                    bottom: BorderSide(width: 2, color: Color(0x3D09BD62)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.24),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 42),
              !isOtpSent
                  ? GestureDetector(
                      onTap: sendOTP,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF09BD62),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 66, vertical: 13),
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0),
                            borderRadius: BorderRadius.circular(5),
                            border: const Border(
                              left: BorderSide(color: Color(0x3D09BD62)),
                              top: BorderSide(color: Color(0x3D09BD62)),
                              right: BorderSide(color: Color(0x3D09BD62)),
                              bottom:
                                  BorderSide(width: 2, color: Color(0x3D09BD62)),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: otpController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter OTP',
                                    hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.24),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: verifyOTP,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF09BD62),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              'Verify OTP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 42),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupEmailScreen()));
                },
                child: const Text(
                  'Don’t have an Account yet? Sign up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
