// ignore_for_file: file_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/controllers/BukuController.dart';
import 'package:flutter/services.dart';

class EditBuku extends StatefulWidget {
  final Map params;
  const EditBuku({super.key, required this.params});

  @override
  State<EditBuku> createState() => _EditBukuState();
}

class _EditBukuState extends State<EditBuku> {
  late BukuController _bukuController;
  bool loading = false;

  final TextEditingController _idBukuAttribute = TextEditingController();
  final TextEditingController _judulAttribute = TextEditingController();
  final TextEditingController _pengarangAttribute = TextEditingController();
  final TextEditingController _tahunTerbitAttribute = TextEditingController();
  final TextEditingController _stokAttribute = TextEditingController();
  // Initial Selected Value
  String? _dropdownValue;
  String? _namaFile;
  File? images;

  @override
  void initState() {
    _bukuController = BukuController();

    _idBukuAttribute.text = widget.params['id'].toString();
    _judulAttribute.text = widget.params['judul'].toString();
    _dropdownValue = widget.params['category_id'].toString();
    _pengarangAttribute.text = widget.params['pengarang'].toString();
    _tahunTerbitAttribute.text = widget.params['tahun'].toString();
    _stokAttribute.text = widget.params['stok'].toString();
    super.initState();
  }

  setData(data) {
    if (data is Map) {
      if (data['key'] == ForSetData.forUpdatedBuku) {
        loading = data['payload'];
      }
    }
  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["jpg", "jpeg", "png"]);

    images = File(result!.files.single.path!);

    setState(() {
      _namaFile = images != null ? images!.path.split('/').last : '...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Buku'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: _judulAttribute,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Judul Buku Anda",
                    labelText: "Judul Buku",
                    suffixIcon: const Icon(Icons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                          // color: primaryButtonColor,
                          ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: _pengarangAttribute,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Pengarang Buku Anda",
                    labelText: "Pengarang Buku",
                    suffixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: FutureBuilder<List>(
                    future: _bukuController.getCategoryInForm(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            suffixIcon: const Icon(Icons.book_online),
                          ),
                          hint: const Text('Pilih Kategori Buku'),
                          value: _dropdownValue,
                          items: data!.map((value) {
                            return DropdownMenuItem<String>(
                              value: value['id'].toString(),
                              child: Text(value['nama_kategori']),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _dropdownValue = value;
                            });
                          },
                        );
                      } else {
                        return const CircularProgressIndicator(
                            // valueColor: new AlwaysStoppedAnimation<Color>(
                            //     primaryButtonColor),
                            );
                      }
                    }),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  controller: _tahunTerbitAttribute,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Tahun Terbit Buku Anda",
                    labelText: "Tahun Terbit",
                    suffixIcon: const Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: _stokAttribute,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    // hintText: "Masukkan Stok Buku Anda",
                    labelText: "Stok",
                    suffixIcon: const Icon(Icons.web_stories),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              _namaFile == null
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: const Center(
                        child: Text(
                          "Change Image",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(images!.path),
                              fit: BoxFit.cover,
                              width: 200,
                              height: 250,
                            ),
                          ),
                          Text(
                            _namaFile!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
              Container(
                // width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: ElevatedButton(
                  // style: ElevatedButton.styleFrom(primary: primaryButtonColor),
                  onPressed: () {
                    // myAlert();
                    _openFileExplorer();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Center(child: Text('Upload Image')),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          FormData formData;
                          if (images != null) {
                            formData = FormData.fromMap({
                              'judul': _judulAttribute.text,
                              'category_id': _dropdownValue,
                              'pengarang': _pengarangAttribute.text,
                              'tahun': _tahunTerbitAttribute.text,
                              'stok': _stokAttribute.text,
                              'path':
                                  await MultipartFile.fromFile(images!.path),
                            });
                          } else {
                            formData = FormData.fromMap({
                              'judul': _judulAttribute.text,
                              'category_id': _dropdownValue,
                              'pengarang': _pengarangAttribute.text,
                              'tahun': _tahunTerbitAttribute.text,
                              'stok': _stokAttribute.text,
                            });
                          }
                          // ignore: use_build_context_synchronously
                          await _bukuController.updateBuku(context, formData,
                              _idBukuAttribute.text, setData);
                        },
                  child: loading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
