// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:perpus_example_case/views/pages/buku/ListBuku.dart';
import 'package:perpus_example_case/views/pages/buku/ListKategoriBuku.dart';
import 'package:perpus_example_case/views/pages/dashboard/Dashboard.dart';
import 'package:perpus_example_case/views/pages/member/Member.dart';
import 'package:perpus_example_case/views/pages/peminjaman/ListPeminjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late List<Widget> children;
  // ignore: prefer_final_fields
  String? _roles;
  int _selectedNavbar = 0;

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _roles = prefs.getString('roles').toString();
    setState(() {
      if (_roles == 'admin') {
        children = [
          const Dashboard(),
          const ListBuku(),
          const ListKategoriBuku(),
          const Member(),
          const ListPeminjaman()
        ];
      } else {
        children = [
          const Dashboard(),
          const ListBuku(),
          const ListPeminjaman()
        ];
      }
    });
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  void initState() {
    setState(() {
      children = [
        const Dashboard()
      ];
    });
    getRoles();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[_selectedNavbar],
      bottomNavigationBar: BottomNavigation(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BottomNavigation() {
    if (_roles == 'admin') {
      return Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.75))
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Buku",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Kategori Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Member',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake_rounded),
              label: 'Peminjaman',
            ),
          ],
          currentIndex: _selectedNavbar,
          selectedItemColor: const Color(0xff130160),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _changeSelectedNavBar,
        ),
      );
    }else{
      return Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.75))
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Buku",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake_rounded),
              label: "Peminjaman",
            ),
          ],
          currentIndex: _selectedNavbar,
          selectedItemColor: const Color(0xff130160),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _changeSelectedNavBar,
        ),
      );
    }
  }
}
