
// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/buku/form/EditKategoriBuku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailKategoriBuku extends StatefulWidget {
  final Map params;
  const DetailKategoriBuku({super.key, required this.params});

  @override
  State<DetailKategoriBuku> createState() => _DetailKategoriBukuState();
}

class _DetailKategoriBukuState extends State<DetailKategoriBuku> {
  String? _detailNamaKategoriBuku;

  Future getDetailCategory(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token;
    token = prefs.getString('token').toString();
    var dio = Dio();
    try {
      var response = await dio.get(
        "${Globals.urlApi}category/${widget.params['id']}",
        data: null,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        setState(() {
          _detailNamaKategoriBuku =
              response.data['data']['category']['nama_kategori'];
        });
      } else {
        AlertDialog alert = AlertDialog(
          title: const Text("Perhatian"),
          content: Text(response.data['message'].toString()),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

        showDialog(context: context, builder: (context) => alert);
        return;
      }
    } on DioError catch (e) {
      AlertDialog alert = AlertDialog(
        title: const Text("Perhatian"),
        content: Text(e.message.toString()),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      showDialog(context: context, builder: (context) => alert);
      return;
    }
  }

  beforeDelete(id) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Hapus"),
      onPressed: () async{
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 10));
      await deleteCategory(id);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Perhatian"),
      content: const Text(
          "Apakah Anda yakin Menghapus Data?"),
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

  Future deleteCategory(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();

    var dio = Dio();
    try {
      var response = await dio.delete(
        "${Globals.urlApi}category/$id/delete",
        data: null,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        AlertDialog alert = AlertDialog(
          title: const Text("Sukses"),
          content: Text(response.data['message'].toString()),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );

        showDialog(context: context, builder: (context) => alert);
        return;
      } else {
        AlertDialog alert = AlertDialog(
          title: const Text("Perhatian"),
          content: Text(response.data['message'].toString()),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

        showDialog(context: context, builder: (context) => alert);
        return;
      }
    } on DioError catch (e) {
      AlertDialog alert = AlertDialog(
        title: const Text("Perhatian"),
        content: Text(e.message.toString()),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      showDialog(context: context, builder: (context) => alert);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailCategory(widget.params);
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kategori Buku'),
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            border:
                Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2),
            shape: BoxShape.rectangle,
          ),
          child: const Icon(
            Icons.category_outlined,
            color: Colors.black,
            size: 100,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 11),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nama Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              const SizedBox(height: 6),
              Text(
                _detailNamaKategoriBuku == null
                    ? "-"
                    : _detailNamaKategoriBuku.toString(),
                style: const TextStyle(
                    fontSize: 15.0, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await beforeDelete(widget.params['id']);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text("Hapus"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditKategoriBuku(params: widget.params),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text("Edit"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
