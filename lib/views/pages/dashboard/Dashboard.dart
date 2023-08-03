// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:perpus_example_case/controllers/DashboardController.dart';
import 'package:perpus_example_case/views/authentication/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardController _dashboardController;

  String? totalBuku;
  String? totalStok;
  String? totalMember;
  String? totalPegawai;
  String? totalPeminjaman;
  String? totalDikembalikan;

  setData(data){
    if(data is Map){
      if(data['key'] == ForSetData.forDashboard){
        setState(() {
          totalBuku =
              data['payload']['totalBuku'].toString();
          totalStok =
              data['payload']['totalStok'].toString();
          totalMember =
              data['payload']['totalMember'].toString();
          totalPegawai =
              data['payload']['totalPegawai'].toString();
          totalPeminjaman =
              data['payload']['totalPeminjaman'].toString();
          totalDikembalikan = data['payload']['totalDikembalikan'].toString();
        });
      }
    }
  }

  @override
  void initState() {
    _dashboardController = DashboardController();
    _dashboardController.getDashboard(context,setData);
    super.initState();
  }

  _logout() async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Logout"),
      onPressed: () async{
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 10));
      await actionLogout();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Perhatian"),
      content: const Text(
          "Yakin Keluar dari Aplikasi?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  actionLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('token');
    if (success == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Authentication(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await _logout();
            },
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(25),
        crossAxisCount: 2,
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.book,
                    size: 70,
                    color: Colors.blueAccent,
                  ),
                  const Text(
                    "Total Buku : ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalBuku != null ? totalBuku! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.list,
                    size: 70,
                    color: Colors.pink,
                  ),
                  const Text(
                    "Total Stok : ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalStok != null ? totalStok! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people,
                    size: 70,
                    color: Colors.red,
                  ),
                  const Text(
                    "Total Member : ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalMember != null ? totalMember! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.work,
                    size: 70,
                    color: Colors.cyan,
                  ),
                  const Text(
                    "Total Pegawai",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalPegawai != null ? totalPegawai! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.waving_hand_sharp,
                    size: 70,
                    color: Colors.green,
                  ),
                  const Text(
                    "Total Dipinjam : ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalPeminjaman != null ? totalPeminjaman! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.handshake,
                    size: 70,
                    color: Colors.purple,
                  ),
                  const Text(
                    "Total Dikembalikan : ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    totalDikembalikan != null ? totalDikembalikan! : "0",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.emoji_emotions,
                    size: 70,
                    color: Colors.yellow,
                  ),
                  Text(
                    "Rated Me :)",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              )),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                await _logout();
              },
              splashColor: Colors.blue,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.logout,
                    size: 70,
                    color: Colors.orange,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
