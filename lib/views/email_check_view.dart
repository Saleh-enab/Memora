import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memora/views/verified_email_view.dart';
import 'package:memora/views/verify_email_view.dart';

class EmailCheckView extends StatefulWidget {
  const EmailCheckView({super.key});

  @override
  State<EmailCheckView> createState() => _EmailCheckViewState();
}

class _EmailCheckViewState extends State<EmailCheckView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEmailVerification();
    });
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser?.emailVerified ?? false) {
      print("You are a verified user");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerifiedEmailView()),
      );
    } else {
      print("You need to verify your Email first");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerifyEmailView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Checking email verification...",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
