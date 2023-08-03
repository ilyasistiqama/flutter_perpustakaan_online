// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinjamBuku extends StatefulWidget {
  final Map params;

  const PinjamBuku(this.params, {super.key});

  @override
  State<PinjamBuku> createState() => _PinjamBukuState();
}

class _PinjamBukuState extends State<PinjamBuku> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDateBack = DateTime.now();

  final TextEditingController _tanggalMulaiPeminjamanController =
      TextEditingController();
  final TextEditingController _tanggalBerakhirPeminjamanController =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _tanggalMulaiPeminjamanController.text =
        DateFormat.yMMMd().format(_selectedDate);
    super.initState();
  }

  _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: _selectedDate,
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _tanggalMulaiPeminjamanController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _tanggalMulaiPeminjamanController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  _selectDateBack(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateBack,
      firstDate: _selectedDate,
      lastDate: DateTime(2040),
    );
    if (newSelectedDate != null) {
      _selectedDateBack = newSelectedDate;
      _tanggalBerakhirPeminjamanController
        ..text = DateFormat.yMMMd().format(_selectedDateBack)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _tanggalMulaiPeminjamanController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  _insertPeminjaman() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    String id;
    token = prefs.getString('token').toString();
    id = prefs.getString('idUser').toString();

    setState(() {
      _tanggalMulaiPeminjamanController.text;
      _tanggalBerakhirPeminjamanController.text;
    });

    var dio = Dio();
    var formData = FormData.fromMap({
      'id_buku': widget.params['id'].toString(),
      'id_member': id,
      'tanggal_peminjaman': _tanggalMulaiPeminjamanController.text,
      'tanggal_pengembalian': _tanggalBerakhirPeminjamanController.text,
      'bypass': '1'
    });

    try {
      var response = await dio.post(
        // ignore: prefer_interpolation_to_compose_strings
        '${Globals.urlApi}peminjaman/book/${widget.params['id']}/member/' + id,
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
      appBar: AppBar(
        title: const Text('Pinjam Buku'),
      ),
      body: Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CoverBuku(widget.params['path'])),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            widget.params['judul'],
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            widget.params['category']['nama_kategori'],
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: TextFormField(
                  readOnly: true,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _tanggalMulaiPeminjamanController,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Tanggal Peminjaman Buku Anda",
                    labelText: "Tanggal Peminjaman",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 7),
                child: TextFormField(
                  readOnly: true,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _tanggalBerakhirPeminjamanController,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Tanggal Pengembalian Buku Anda",
                    labelText: "Tanggal Pengembalian",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () {
                        _selectDateBack(context);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: (isLoading)
                      ? null
                      : () async {
                          await _insertPeminjaman();
                        },
                  icon: (isLoading)
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.playlist_add_rounded),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CoverBuku(params) {
    if (params == null) {
      return const Image(
          height: 250,
          // ignore: prefer_interpolation_to_compose_strings
          image: NetworkImage(
              '${Globals.url}storage/image/book/default-image.png'),
          fit: BoxFit.cover);
    } else {
      return Image(
          height: 250,
          // ignore: prefer_interpolation_to_compose_strings
          image: NetworkImage('${Globals.url}storage/' + params),
          fit: BoxFit.cover);
    }
  }
}
