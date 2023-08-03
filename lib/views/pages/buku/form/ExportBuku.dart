// ignore_for_file: file_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportBuku extends StatefulWidget {
  const ExportBuku({super.key});

  @override
  State<ExportBuku> createState() => _ExportBukuState();
}

class _ExportBukuState extends State<ExportBuku> {

  final TextEditingController txtFilePicker = TextEditingController();
  File? file;
  // fungsi untuk select file
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        file = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future exportTemplateExcel() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        "${Globals.urlApi}book/download/template",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data['status'] == 200) {
        // ignore: deprecated_member_use
        await launch(Globals.url + response.data['path']);
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
    // return [];
  }

  _insertExcel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'file_import': await MultipartFile.fromFile(file!.path),
    });
    // log(file.toString());
    try {
      var response = await dio.post(
        "${Globals.urlApi}book/import/excel",
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
              },
            ),
          ],
        );

        showDialog(context: context, builder: (context) => alert);
      }else{
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
      appBar: AppBar(
        title: const Text('Export Buku'),
         actions: <Widget>[
          IconButton(
            onPressed: () async {
              await exportTemplateExcel();
            },
            icon: const Icon(Icons.import_export),
          ),
        ],
      ),
      body: buildFilePicker(),
    );
  }

  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    readOnly: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'File harus diupload';
                      } else {
                        return null;
                      }
                    },
                    controller: txtFilePicker,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText: 'Upload File',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: 24.0,
                ),
                label:
                    const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
                onPressed: () {
                  selectFile();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(122, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Upload File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              _insertExcel();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

