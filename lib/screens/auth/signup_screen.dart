import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import 'package:bcrypt/bcrypt.dart';

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

  void _signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String confirm_password = confirm_passwordController.text;

    try {
      final hashPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      bool isValidEmail(String email) {
        final emailRegex =
            RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$');
        return emailRegex.hasMatch(email);
      }

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter email address')),
        );
        return;
      }
      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please conrrect your email')),
        );
        return;
      }

      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter password')),
        );
        return;
      }
      if (confirm_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter confirm-password')),
        );
        return;
      }
      log(pb.baseURL);
      if (confirm_password != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Confirm-Password Not match!')),
        );
        return;
      }
      final records =
          await pb.collection('user').getList(filter: 'email = "$email"');

      if (records.items.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already exists, Go to login.')),
        );
        return;
      }

      final body = <String, dynamic>{
        "email": email,
        "password": hashPassword,
        "login_status": false,
        "role_admin": false
      };

      final record = await pb.collection('user').create(body: body);
      log('Signup successful: $record');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('sign up faild')),
      );
    }
  }

  @override
  void initState() {
    final record = pb.collection('user').getFullList();
    log(record.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF201A09),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/signupImaage.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Email input fiel
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: PaletteTheme.textDesc,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 40),

              // Password input field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: PaletteTheme.textDesc,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(height: 40),

              // Password again input field
              TextField(
                controller: confirm_passwordController,
                decoration: InputDecoration(
                  labelText: 'Confirm-Password',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock_clock,
                    color: PaletteTheme.textDesc,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Sign In? ',
                            style: TextStyle(color: PaletteTheme.title),
                            children: [
                              TextSpan(
                                text: "Already have an account",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _signUp, // Use the _login method
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: PaletteTheme.textDesc),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PaletteTheme.yellow,
                        minimumSize: Size(100, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
