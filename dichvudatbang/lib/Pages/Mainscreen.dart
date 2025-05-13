import 'package:dichvudatbang/Pages/page1/page1.dart';
import 'package:dichvudatbang/Pages/page2/page2.dart';
import 'package:dichvudatbang/Pages/page3/page3.dart';
import 'package:dichvudatbang/Pages/profile/profile.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int chonTab = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> screens = [
    Page1(),
    Page2(),
    Page3(),
    Profile(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[chonTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chonTab,
        onTap: (index) {
          setState(() {
            chonTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: 'Trang 1', backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: 'Trang 2', backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: 'Trang 3', backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile', backgroundColor: Colors.blue),
        ]
      ),
    );
  }
}
