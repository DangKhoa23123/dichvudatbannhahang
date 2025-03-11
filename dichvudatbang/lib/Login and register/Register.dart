import 'dart:convert';
import 'package:dichvudatbang/Login%20and%20register/Login.dart';
import 'package:dichvudatbang/Login%20and%20register/Subscreen.dart';
import 'package:dichvudatbang/Pages/Mainscreen.dart';
import 'package:dichvudatbang/ipconfig.dart';
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
        Uri.parse(
            '${ApiConfig.baseUrl}/api/register'), // Đổi thành IP nếu test trên thiết bị thật
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
        Future.delayed(Duration(seconds: 1), () {
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
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    // onPressed: () => Navigator.pushReplacement(
                    //   context,
                    //   PageRouteBuilder(
                    //     transitionDuration: const Duration(
                    //         milliseconds: 200), // Thời gian animation
                    //     pageBuilder: (context, animation, secondaryAnimation) =>
                    //         const Mainscreen(),
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       return SlideTransition(
                    //         position: Tween<Offset>(
                    //           begin: const Offset(
                    //               -1.0, 0.0), // Bắt đầu từ bên phải
                    //           end: Offset.zero, // Kết thúc ở vị trí bình thường
                    //         ).animate(animation),
                    //         child: child,
                    //       );
                    //     },
                    //   ),
                    // ),
                    // child: const Text('Đăng Ký'),
                    onPressed:
                        _register, // Gọi hàm đăng ký thay vì chuyển trang ngay lập tức
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
