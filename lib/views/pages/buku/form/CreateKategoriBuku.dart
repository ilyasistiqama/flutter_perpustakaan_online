// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateKategoriBuku extends StatefulWidget {
  const CreateKategoriBuku({super.key});

  @override
  State<CreateKategoriBuku> createState() => _CreateKategoriBukuState();
}

class _CreateKategoriBukuState extends State<CreateKategoriBuku> {
  late final TextEditingController _namaKategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  createCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token;
    token = prefs.getString('token').toString();
    var dio = Dio();
    var formData =
        FormData.fromMap({'nama_kategori': _namaKategoriController.text});
    try {
      var response = await dio.post(
        "${Globals.urlApi}category/create",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 201) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Kategori Buku')),
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
                await createCategory();
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
