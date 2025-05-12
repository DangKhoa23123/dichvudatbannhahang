import 'dart:convert';
import 'package:dichvudatbang/Login%20and%20register/Login.dart';
import 'package:dichvudatbang/Login%20and%20register/Subscreen.dart';
import 'package:dichvudatbang/Pages/Mainscreen.dart';
import 'package:dichvudatbang/ipconfig.dart';
import 'package:dichvudatbang/ui/text_field_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar("Mật khẩu xác nhận không khớp", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _showSnackBar("Đăng ký thành công!", Colors.green);
        Future.delayed(Duration(microseconds: 500), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Subscreen(
                email: _emailController.text,
                password: _passwordController.text,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0), // Bắt đầu từ bên phải
                    end: Offset.zero, // Kết thúc ở vị trí bình thường
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        });
      } else {
        _showSnackBar(responseData['error'], Colors.red);
      }
    } catch (e) {
      _showSnackBar("Lỗi kết nối server!", Colors.red);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.account_circle, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextFieldUi(
                controller: _usernameController,
                obscureText: false,
                labelText: 'Họ và tên'),
            const SizedBox(height: 10),
            TextFieldUi(
                controller: _emailController,
                obscureText: false,
                labelText: 'Email'),
            const SizedBox(height: 10),
            TextFieldUi(
                controller: _phoneController,
                obscureText: false,
                labelText: 'Số điện thoại'),
            const SizedBox(height: 10),
            TextFieldUi(
                controller: _passwordController,
                obscureText: true,
                labelText: 'Mật khẩu'),
            const SizedBox(height: 10),
            TextFieldUi(
                controller: _confirmPasswordController,
                obscureText: true,
                labelText: 'Nhập lại mật khẩu'),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : const Text('Đăng Ký'),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
