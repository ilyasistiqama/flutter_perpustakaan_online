
// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditKategoriBuku extends StatefulWidget {
  final Map params;

  const EditKategoriBuku({super.key, required this.params});

  @override
  State<EditKategoriBuku> createState() => _EditKategoriBukuState();
}

class _EditKategoriBukuState extends State<EditKategoriBuku> {
  late final TextEditingController _namaKategoriController = TextEditingController();

  @override
  void initState() {
    _namaKategoriController.text = widget.params['nama_kategori'];
    super.initState();
  }

  updateCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token;
    token = prefs.getString('token').toString();
    var dio = Dio();
    var formData =
        FormData.fromMap({'nama_kategori': _namaKategoriController.text});
    try {
      var response = await dio.post(
        "${Globals.urlApi}category/update/${widget.params['id']}",
        data: formData,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kategori Buku')),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              controller: _namaKategoriController,
              decoration: InputDecoration(
                // hintText: "Masukkan Kategori Buku Anda",
                labelText: "Nama Kategori Buku",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await updateCategory();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Submit'),
            ),
          ]),
        ),
      ),
    );
  }
}
