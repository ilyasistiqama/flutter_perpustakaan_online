// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class KembalikanBuku extends StatefulWidget {
  final Map params;
  const KembalikanBuku(this.params, {super.key});

  @override
  State<KembalikanBuku> createState() => _KembalikanBukuState();
}

class _KembalikanBukuState extends State<KembalikanBuku> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _textDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textDateController.text = DateFormat.yMMMd().format(_selectedDate);
  }

  _insertPengembalian() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    String id;
    token = prefs.getString('token').toString();
    id = prefs.getString('idUser').toString();

    setState(() {
      _textDateController.text;
    });

    var dio = Dio();
    var formData = FormData.fromMap({
      'id_buku': widget.params['id'].toString(),
      'id_member': id,
      'tanggal_pengembalian': _textDateController.text,
    });

    try {
      var response = await dio.post(
        '${Globals.urlApi}peminjaman/book/${widget.params['id']}/return',
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
      // print(response.data['status']);
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

  _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: _selectedDate,
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textDateController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kembalikan Buku')),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CoverBuku(widget.params['book']['path']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              widget.params['book']['judul'],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "${"Peminjam : " + widget.params['member']['name']}, " +
                  widget.params['member']['email'],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "Dari ${widget.params['tanggal_peminjaman']}, sampai dengan ${widget.params['tanggal_pengembalian']}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _textDateController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Tanggal Pengembalian Buku Anda",
                    labelText: "Tanggal Pengembalian",
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
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _insertPengembalian();
                    },
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
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
