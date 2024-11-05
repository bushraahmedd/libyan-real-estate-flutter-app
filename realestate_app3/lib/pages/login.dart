import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realestate_app3/pages/root.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RootApp(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'لم يتم العثور على المستخدم. يرجى التحقق من البريد الإلكتروني الخاص بك.';
          break;
        case 'wrong-password':
          errorMessage = 'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح. يرجى التحقق من البريد الإلكتروني الخاص بك.';
          break;
        case 'user-disabled':
          errorMessage = 'تم تعطيل المستخدم. يرجى الاتصال بالدعم.';
          break;
        default:
          errorMessage = 'حدث خطأ أثناء تسجيل الدخول. الرجاء المحاولة مرة أخرى.';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تسجيل الدخول. الرجاء المحاولة مرة أخرى.',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RootApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تسجيل الدخول',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 300,
                  height: 300,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to forgot password screen
                    },
                    child: Text(
                      'نسيت كلمة المرور؟',
                      style: GoogleFonts.cairo(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to signup screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "",
                      style: GoogleFonts.cairo(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟ ',
                    style: GoogleFonts.cairo(fontSize: 16.0  , fontWeight: FontWeight.bold,),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to signup screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'إنشاء حسابك الآن',
                      style: GoogleFonts.cairo(
        
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: _buildSignInButton(
                  text: 'تسجيل الدخول',
                  onPressed: _login,
                  color: Color.fromARGB(255, 21, 0, 214),
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: _buildSignInButton(
                  text: 'الدخول كضيف',
                  onPressed: _loginAsGuest,
                  color: Colors.grey,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.cairo(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
      ),
    );
  }
}
