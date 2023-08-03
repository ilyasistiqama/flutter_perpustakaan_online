// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/peminjaman/form/DetailPeminjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPeminjaman extends StatefulWidget {
  const ListPeminjaman({super.key});

  @override
  State<ListPeminjaman> createState() => _ListPeminjamanState();
}

class _ListPeminjamanState extends State<ListPeminjaman> {
  List _listPeminjaman = [];
  int page = 1;
  bool _nextPage = false;
  bool checkDataEmpty = false;

  Future getPeminjaman() async {
    setState(() {
      _listPeminjaman = [];
    });
    _nextPage = false;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      var queryParams = <String, dynamic>{"page": page};

      var response = await dio.get(
        "${Globals.urlApi}peminjaman",
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${prefs.getString('token').toString()}",
          },
        ),
      );

      if (response.data['status'] == 200) {
        setState(() {
          _listPeminjaman = response.data['data']['peminjaman']['data'];
           if(_listPeminjaman.isEmpty){
            checkDataEmpty = true;
          }
          
          ((_listPeminjaman.length >= 10)
              ? _nextPage = true
              : _nextPage = false);
        });
      } else {
        AlertDialog alert = AlertDialog(
          title: const Text("Perhatian"),
          content: Text(response.data['message']),
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

   void _refresh() {
    setState(() {
      _listPeminjaman = [];
      page = 1;
    });
    getPeminjaman();
  }

  @override
  void initState() {
    getPeminjaman();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Peminjaman')),
      body: Column(
        children: [
          _listPeminjaman.isEmpty && checkDataEmpty == false
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _listPeminjaman.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                            _listPeminjaman[index]['member']['name'] +
                                ' - ' +
                                _listPeminjaman[index]['book']['judul'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(_listPeminjaman[index]
                                ['tanggal_peminjaman'] +
                            ' - ' +
                            _listPeminjaman[index]['tanggal_pengembalian']),
                        leading: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(20),
                            child: CoverBuku(_listPeminjaman[index]['book']['path']),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPeminjaman(_listPeminjaman[index]),
                            ),
                          );

                          _refresh();
                        },
                      );
                    },
                  ),
                ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_listPeminjaman.isEmpty && checkDataEmpty == true
                        ? "Tidak ada Data"
                        : "Page : $page"),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    (page != 1)
                        ? ElevatedButton(
                            onPressed: () {
                              page--;
                              getPeminjaman();
                            },
                            child: const Icon(Icons.navigate_before),
                          )
                        : const ElevatedButton(
                            onPressed: null,
                            child: Icon(Icons.navigate_before),
                          ),
                    (page != 1)
                        ? const SizedBox(width: 10)
                        : const SizedBox(width: 10),
                    (_nextPage == true)
                        ? ElevatedButton(
                            onPressed: () {
                              page++;
                              getPeminjaman();
                            },
                            child: const Icon(Icons.navigate_next),
                          )
                        : const ElevatedButton(
                            onPressed: null,
                            child: Icon(Icons.navigate_next),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget CoverBuku(params) {
    if (params == null) {
      return const Image(
          // ignore: prefer_interpolation_to_compose_strings
          image: NetworkImage(
              '${Globals.url}storage/image/book/default-image.png'),
          fit: BoxFit.cover);
    } else {
      return Image(
          // ignore: prefer_interpolation_to_compose_strings
          image: NetworkImage('${Globals.url}storage/' + params),
          fit: BoxFit.cover);
    }
  }
}
