import 'dart:convert';
import 'package:dichvudatbang/Pages/Mainscreen.dart';
import 'package:dichvudatbang/ipconfig.dart';
import 'package:dichvudatbang/ui/social_icon_ui.dart';
import 'package:dichvudatbang/ui/text_field_ui.dart';
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
  bool _isLoading = false;

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
        const SnackBar(
            content: Text("Vui lòng nhập đầy đủ thông tin!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}/login');
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
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Đăng nhập thành công!"),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Mainscreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data["message"] ?? "Đăng nhập thất bại!"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Lỗi kết nối đến server!"),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  var mySB = SizedBox(height: 20);

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
            TextFieldUi(
                controller: _emailController,
                obscureText: false,
                labelText: 'Email'),
            const SizedBox(height: 20),
            TextFieldUi(
                controller: _passwordController,
                obscureText: true,
                labelText: 'Mật khẩu'),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
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
                SocialIconUi(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Mainscreen()),
                      );
                    },
                    iconPath: 'assets/Google.png'),
                const SizedBox(width: 20),
                SocialIconUi(
                    onTap: () {
                      print("This is FaceBook");
                    },
                    iconPath: 'assets/Facebook.png'),
                const SizedBox(width: 20),
                SocialIconUi(
                    onTap: () {
                      print("This is Twitter");
                    },
                    iconPath: 'assets/Twitter.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
