// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/peminjaman/form/KembalikanBuku.dart';

class DetailPeminjaman extends StatefulWidget {
  final Map params;

  const DetailPeminjaman(this.params, {super.key});

  @override
  State<DetailPeminjaman> createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Peminjaman'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // ignore: duplicate_ignore
            child: CoverBuku(widget.params['book']['path']),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.params['book']['judul'],
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Peminjam : " +
                  widget.params['member']['name'] +
                  ", " +
                  widget.params['member']['email'],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              'Dari : ' + widget.params['tanggal_peminjaman'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            'Sampai : ' + widget.params['tanggal_pengembalian'],
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.params['status'].toString() != '3')
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KembalikanBuku(widget.params),
                          ),
                        );
                      },
                      child: const Text('Kembalikan Buku'),
                    ),
                  ),
                if (widget.params['status'].toString() == '3')
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      'Telah di Kembalikan pada Tanggal : ' +
                          widget.params['tanggal_pengembalian'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
