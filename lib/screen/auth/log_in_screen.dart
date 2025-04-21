import 'package:absen_dulu/screen/home_screen.dart';
import 'package:absen_dulu/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Tambahan untuk gesture klik pada TextSpan

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background atas
          Positioned.fill(
            child: Image.asset('assets/images/bg_login.png', fit: BoxFit.cover),
          ),

          // Layout responsif
          LayoutBuilder(
            builder: (context, constraints) {
              final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(
                  bottom:
                      keyboardOpen
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 0,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height:
                        keyboardOpen
                            ? constraints.maxHeight * 0.75
                            : constraints.maxHeight * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg_login_form.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Login to your account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text("Email"),
                          const SizedBox(height: 5),

                          // Email Field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              height: 60,
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          const Text("Password"),
                          const SizedBox(height: 5),

                          // Password Field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              height: 60,
                              child: TextField(
                                obscureText: true,
                                controller: password,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (_) {}),
                              const Text("Remember me"),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Forgot Password?"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                await ApiService().loginUser(
                                  email: email.text,
                                  password: password.text,
                                );
                                // Navigasi ke halaman Home
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login berhasil")),
                                );
                              },
                              // _isLoading
                              //     ? null
                              //     : () async {
                              //       setState(() => _isLoading = true);

                              //       final result = await ApiService()
                              //           .loginUser(
                              //             email: email.text,
                              //             password: password.text,
                              //           );

                              //       setState(() => _isLoading = false);

                              //       if (result is RegisterData) {
                              //         ScaffoldMessenger.of(
                              //           context,
                              //         ).showSnackBar(
                              //           SnackBar(
                              //             content: Text(
                              //               result.message ??
                              //                   "Login berhasil",
                              //             ),
                              //           ),
                              //         );

                              //         // Navigasi ke halaman Home
                              //         Navigator.pushReplacementNamed(
                              //           context,
                              //           '/home',
                              //         );
                              //       } else {
                              //         ScaffoldMessenger.of(
                              //           context,
                              //         ).showSnackBar(
                              //           const SnackBar(
                              //             content: Text(
                              //               "Terjadi kesalahan. Coba lagi nanti.",
                              //             ),
                              //           ),
                              //         );
                              //       }
                              //     },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D3B66),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don’t have account? ",
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: const TextStyle(
                                      color: Color(0xFF0D3B66),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                              context,
                                              '/signup',
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or continue with"),
                              ),
                              Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 36,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
