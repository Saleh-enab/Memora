import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
        backgroundColor: Color(0xFFD7CCC8),
        foregroundColor: Colors.brown[900],
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: ElevatedButton.icon(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD7CCC8),
              foregroundColor: Colors.brown.shade900,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xFF6D4C41), width: 2),
              ),
              elevation: 6,
            ),
            icon: Icon(
              Icons.mark_email_read_sharp,
              color: Colors.brown.shade900,
              size: 23,
            ),
            label:
                _isLoading
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.brown,
                      ),
                    )
                    : Text(
                      "Send Email Verification",
                      style: TextStyle(fontSize: 20),
                    ),
          ),
        ),
      ),
    );
  }
}
