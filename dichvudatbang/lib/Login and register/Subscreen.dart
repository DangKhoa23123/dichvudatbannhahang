import 'package:dichvudatbang/Login%20and%20register/Login.dart';
import 'package:dichvudatbang/Login%20and%20register/Register.dart';
import 'package:flutter/material.dart';

class Subscreen extends StatefulWidget {
  final String? email;
  final String? password;

  const Subscreen({super.key, this.email, this.password});

  @override
  _SubscreenState createState() => _SubscreenState();
}

class _SubscreenState extends State<Subscreen> {
  int Tabchon = 0;
  late List<Widget> screens;
  

  @override
  void initState() {
    super.initState();
    screens = [
      Login(email: widget.email, password: widget.password),
      Register(),
    ];
  }


  void _changeTab(int index) {
    setState(() {
      Tabchon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F2F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => _changeTab(0),
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: Tabchon == 0 ? FontWeight.bold : FontWeight.normal,
                  color: Tabchon == 0 ? Colors.black : Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _changeTab(1),
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: Tabchon == 1 ? FontWeight.bold : FontWeight.normal,
                  color: Tabchon == 1 ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Vuốt từ phải sang trái -> Chuyển từ Login sang Register
          if (details.primaryVelocity! < 0 && Tabchon == 0) {
            _changeTab(1);
          }
          // Vuốt từ trái sang phải -> Chuyển từ Register sang Login
          else if (details.primaryVelocity! > 0 && Tabchon == 1) {
            _changeTab(0);
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: (Tabchon == 1) ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: screens[Tabchon],
        ),
      ),
    );
  }
}
