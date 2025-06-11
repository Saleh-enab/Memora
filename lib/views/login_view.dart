import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memora/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                        SizedBox(height: 24),
                        // Email field
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: _email,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.brown[800],
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.brown),
                              hintText: "Enter your Email",
                              hintStyle: TextStyle(color: Colors.brown),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 12),

                        // Password field
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: _password,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscurePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.brown[800],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.brown),
                              hintText: "Enter your password",
                              hintStyle: TextStyle(color: Colors.brown),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Register Button
                        SizedBox(
                          width: 300,
                          child: ElevatedButton.icon(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        try {
                                          final userCredential =
                                              await FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                    email: _email.text,
                                                    password: _password.text,
                                                  );
                                          print(
                                            "User logged in: $userCredential",
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Logged In successfully!",
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor:
                                                  Colors.brown[400],
                                            ),
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          String errorMessage;
                                          switch (e.code) {
                                            case 'user-not-found':
                                            case 'wrong-password':
                                              errorMessage =
                                                  'Wrong Email or Password';
                                              break;
                                            case 'invalid-email':
                                              errorMessage =
                                                  'Invalid Email Address';
                                              break;
                                            case 'user-disabled':
                                              errorMessage =
                                                  'This account has been disabled';
                                              break;
                                            case 'too-many-requests':
                                              errorMessage =
                                                  'Too many attempts. Try again later';
                                              break;
                                            default:
                                              errorMessage =
                                                  e.message ?? 'Login failed';
                                          }
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                errorMessage,
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } finally {
                                          if (!mounted) return;
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD7CCC8),
                              foregroundColor: Colors.brown.shade900,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Color(0xFF6D4C41),
                                  width: 2,
                                ),
                              ),
                              elevation: 6,
                            ),
                            icon: Icon(Icons.login, color: Colors.brown),
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
                                      "Log In",
                                      style: TextStyle(fontSize: 16),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          default:
            // 🌀 Simple loading screen while Firebase initializes
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text("Loading..."),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
