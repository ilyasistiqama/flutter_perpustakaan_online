// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:perpus_example_case/controllers/BukuController.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/buku/form/EditBuku.dart';
import 'package:perpus_example_case/views/pages/peminjaman/form/PinjamBuku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBuku extends StatefulWidget {
  final Map data;

  const DetailBuku(this.data, {super.key});

  @override
  State<DetailBuku> createState() => _DetailBukuState();
}

class _DetailBukuState extends State<DetailBuku> {
  late BukuController _bukuController;
  String? _roles;

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roles = prefs.getString('roles').toString();
    });
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
      onPressed: () async {
        Navigator.pop(context);
        Future.delayed(const Duration(seconds: 10));
        await _bukuController.deleteBuku(id, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Perhatian"),
      content: const Text("Apakah Anda yakin Menghapus Data?"),
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

  @override
  void initState() {
    _bukuController = BukuController();
    getRoles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CoverBuku(widget.data['path']),
          ),
          Text(
            widget.data['judul'],
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Kode Buku: " + widget.data['kode_buku'],
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Kategori: " + widget.data['category']['nama_kategori'],
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Pengarang: " + widget.data['pengarang'],
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Tahun Terbit: " + widget.data['tahun'],
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Sisa Stok : ${widget.data['stok']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          ButtonInDetailBuku(widget.data),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ButtonInDetailBuku(params) {
    if (_roles == 'admin') {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: params['stok'] < 1
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBuku(params: params),
                          ),
                        );
                      },
                child: const Text('Edit Buku'),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  await beforeDelete(params['id']);
                },
                child: const Text('Hapus Buku'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: params['stok'] < 1
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PinjamBuku(params),
                          ),
                        );
                      },
                child: const Text('Pinjam Buku'),
              ),
            ),
          ],
        ),
      );
    }
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
