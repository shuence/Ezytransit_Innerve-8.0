// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezytransit_innerve/screens/auth/signin.dart';
import 'package:ezytransit_innerve/screens/auth/signup_mobile.dart';
import 'package:ezytransit_innerve/widgets/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ezytransit_innerve/screens/Home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupEmailScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> createAccount(BuildContext context) async {
    try {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access the newly created user
      User? user = userCredential.user;

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user', // Default empty role
        'organization': '', // Default empty organization
        'phone_number': '', // Default empty phone number
        'profile_image_url': '', // Default empty profile image URL
      });

      // Save user data locally
      saveUserDataLocally(name, email, user.uid, '', '', '', '');

      // Navigate to home screen
      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              

      CustomSnackbar.showSuccess(
          context, "message: Account created successfully!");
    } catch (e) {
      // Handle account creation errors
      print("Error creating account: $e");
      // Display error message to user
      CustomSnackbar.showError(context, "Error creating account: $e");
    }
  }

  Future<void> createAccountWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create a new credential
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(googleCredential);

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'role': 'user', // Default empty role
          'organization': '', // Default empty organization
          'phone_number': '', // Default empty phone number
          'profile_image_url': '', // Default empty profile image URL
        });

        // Save user data locally
        saveUserDataLocally(
            userCredential.user!.displayName ?? "",
            userCredential.user!.email ?? "",
            userCredential.user!.uid,
            '',
            '',
            '',
            '');

        CustomSnackbar.showSuccess(
            context, "message: Account created successfully!");

        // Navigate to home screen or any other screen after successful sign-up
       Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              
      } else {
        // Handle sign-in errors
        print("Error signing in with Google: User cancelled the sign-in");
        // Display error message to user
        CustomSnackbar.showError(context,
            "Error signing in with Google: User cancelled the sign-in");
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      // Display error message to user
      CustomSnackbar.showError(context, "Error signing in with Google: $e");
    }
  }

// Save user data locally using shared preferences
  Future<void> saveUserDataLocally(
      String name,
      String email,
      String uid,
      String role,
      String organization,
      String phoneNumber,
      String profileImageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('uid', uid);
    await prefs.setString('role', role);
    await prefs.setString('organization', organization);
    await prefs.setString('phone_number', phoneNumber);
    await prefs.setString('profile_image_url', profileImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ezytranzit.png',
                width: 150,
                height: 100,
              ),
              const Text(
                'SIGN UP',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Dela Gothic One',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter the following details for Creating an account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Enter Your Name', nameController),
              const SizedBox(height: 16),
              _buildTextField('Enter Email', emailController),
              const SizedBox(height: 16),
              _buildTextField('Enter Password', passwordController),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => createAccount(context),
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09BD62),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupScreen()));
              
              },
                  child: Container(
                    width: 260, // Adjust width as needed
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/phone.png',
                          width: 24,
                          color: Colors.white,
                          height: 24,
                        ),
                        const SizedBox(
                            width:
                                10), // Add some space between the icon and text
                        const Flexible(
                          // Wrap the Text widget with Flexible
                          child: Text(
                            'Sign up with Mobile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    createAccountWithGoogle(context);
                  },
                  child: Container(
                    width: 260, // Adjust width as needed
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                            width:
                                10), // Add some space between the icon and text
                        const Flexible(
                          // Wrap the Text widget with Flexible
                          child: Text(
                            'Sign up with Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an Account yet?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInScreen()));
                    },
                    child: const Text(
                      ' Sign in',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
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
    );
  }
}
