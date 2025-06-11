import 'package:flutter/material.dart';

class VerifiedEmailView extends StatelessWidget {
  const VerifiedEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email verified"),
        backgroundColor: Color(0xFFD7CCC8),
        foregroundColor: Colors.brown[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 70, color: Colors.green),
            SizedBox(height: 12),
            Text(
              "Your Email is verified",
              style: TextStyle(fontSize: 25, color: Colors.brown[900]),
            ),
          ],
        ),
      ),
    );
  }
}
