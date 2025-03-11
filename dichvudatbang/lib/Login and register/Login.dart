import 'dart:convert';
import 'package:dichvudatbang/Pages/Mainscreen.dart';
import 'package:dichvudatbang/ipconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  final String? email;
  final String? password;

  const Login({super.key, this.email, this.password});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false; // Kiểm soát trạng thái loading

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email ?? "");
    _passwordController = TextEditingController(text: widget.password ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Xử lý an toàn hơn với null check
        // globals.globalUserName = data['user']?['username'] ?? _usernameController.text;

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng nhập thành công!"), backgroundColor: Colors.green),
        );
        
         Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 200), // Thời gian animation
          pageBuilder: (context, animation, secondaryAnimation) => const Mainscreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0), // Bắt đầu từ bên phải
                end: Offset.zero, // Kết thúc ở vị trí bình thường
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Đăng nhập thất bại!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi kết nối đến server!"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              child: Icon(Icons.account_circle, size: 125, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login, // Gọi hàm đăng nhập
                    child: const Text('Đăng nhập'),
                  ),
            const SizedBox(height: 10),
            Text(
              'Đăng nhập với',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => print("Nhấn vào Google"),
                  child: Image.asset('assets/Google.png', width: 40),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => print("Nhấn vào Facebook"),
                  child: Image.asset('assets/Facebook.png', width: 40),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => print("Nhấn vào Twitter"),
                  child: Image.asset('assets/Twitter.png', width: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
