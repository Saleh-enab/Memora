import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memora/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

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
                          "Create an Account",
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
                            obscureText: _obscurePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.brown[700],
                              ),
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
                              hintText: "Enter a strong password",
                              hintStyle: TextStyle(color: Colors.brown),
                              helperText:
                                  "At least 8 characters, with numbers & symbols",
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
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              final strongPassword = RegExp(
                                r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                              );
                              if (!strongPassword.hasMatch(value)) {
                                return 'Use letters, numbers & symbols';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Confirm Password field
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: _confirmPassword,
                            obscureText: _obscurePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.brown[800],
                              ),
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
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(color: Colors.brown),
                              hintText: "Re-enter your password",
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
                                return 'Please confirm your password';
                              }
                              if (value != _password.text) {
                                return 'Passwords do not match';
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
                                                  .createUserWithEmailAndPassword(
                                                    email: _email.text,
                                                    password: _password.text,
                                                  );
                                          print(
                                            "User created: $userCredential",
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center,
                                                "Registration successful!",
                                              ),
                                              backgroundColor:
                                                  Colors.brown[400],
                                            ),
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          String errorMessage;
                                          switch (e.code) {
                                            case 'email-already-in-use':
                                              errorMessage =
                                                  'This email is already in use';
                                              break;
                                            case 'too-many-requests':
                                              errorMessage =
                                                  'Too many attempts. Try again later';
                                              break;
                                            default:
                                              errorMessage =
                                                  e.message ??
                                                  'Registration failed';
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
                            icon: Icon(Icons.app_registration),
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
                                      "Register",
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
