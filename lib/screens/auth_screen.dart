import 'package:flutter/material.dart';
import 'package:online_shopping_provider/provider/auth.dart';
import 'package:online_shopping_provider/services/http_exeption.dart';
import 'package:provider/provider.dart';

enum AuthMode { register, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Xatolik"),
            content: Text(message),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(ctx);
              }, child: const Text("Okay!"),),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      ///save form
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.login) {
          //Login
          await Provider.of<Auth>(context, listen: false).signIn(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          //Register
          await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi";
        if (error.message.contains("EMAIL_EXISTS")) {
          errorMessage = "Bu email oldin ro'yxatdan o'tgan";
        } else if (error.message.contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
          errorMessage = "Ko'p urunish bo'ldi keyinroq urinib ko'ring";
        } else if (error.message.contains("EMAIL_NOT_FOUND")) {
          errorMessage = "Bu email orqali foydalanuvchi ro'yxatdan o'tmagan";
        } else if (error.message.contains("INVALID_PASSWORD")) {
          errorMessage = "Prol nato'g'ri";
        } else if (error.message.contains("USER_DISABLED")) {
          errorMessage = "Bu foydalanuvchi bloklangan";
        }else if (error.message.contains("INVALID_LOGIN_CREDENTIALS")) {
          errorMessage = "Login yoki parol xato!";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage = "Kechirasiz xatolik sodir bo'ldi";
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/logo.png'),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email manzil"),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Iltimos email manzil kiriting";
                    } else if (!email.contains("@")) {
                      return "Iltimos to'g'ri email kiriting";
                    }
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Parol"),
                  controller: _passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos parolni kiritng";
                    } else if (password.length < 6) {
                      return "Parol juda qisqa";
                    }
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.register)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Parolni tasdiqlang"),
                        validator: (confirmedPass) {
                          if (_passwordController.text != confirmedPass) {
                            return "Parollar bir biriga mos kelmadi";
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 60),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: Text(_authMode == AuthMode.login
                      ? "Kirish"
                      : "RO'YXATDAN O'TISH"),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.login
                        ? "Ro'yxatdan o'tish"
                        : "Kirish",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
