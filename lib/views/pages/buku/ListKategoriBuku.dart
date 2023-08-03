// ignore_for_file: file_names

import 'package:banner_listtile/banner_listtile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/buku/form/CreateKategoriBuku.dart';
import 'package:perpus_example_case/views/pages/buku/form/DetailKategoriBuku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListKategoriBuku extends StatefulWidget {
  const ListKategoriBuku({super.key});

  @override
  State<ListKategoriBuku> createState() => _ListKategoriBukuState();
}

class _ListKategoriBukuState extends State<ListKategoriBuku> {
  List _listKategoriBuku = [];
  late String _role;
  bool _visible = false;
  int page = 1;
  bool _nextPage = false;
  bool checkDataEmpty = false;
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('roles').toString();
      if (_role == 'admin') {
        _visible = true;
      }
    });
  }

  Future getKategoriBuku() async {
    setState(() {
      _listKategoriBuku = [];
      _nextPage = false;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      var queryParams = <String, dynamic>{"page": page, "search": _search};

      var response = await dio.get(
        "${Globals.urlApi}category/all",
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
          _listKategoriBuku = response.data['data']['categories']['data'];
          if(_listKategoriBuku.isEmpty){
            checkDataEmpty = true;
          }

          ((_listKategoriBuku.length >= 9)
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

  @override
  void initState() {
    getRoles();
    getKategoriBuku();
    super.initState();
  }

  Future search() async {
    setState(() {
      page = 1;
      _search = _searchController.text;
      getKategoriBuku();
    });
  }

  void refresh() {
    if (mounted) {
      setState(() {
        getKategoriBuku();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kategori Buku'),
      ),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(7),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    // hintText: "Masukkan Kategori Buku Anda",
                    labelText: "Cari Kategori Buku",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                          page = 1;
                          _search = '';
                        });
                        getKategoriBuku();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(60, 55),
              ),
              onPressed: () async {
                await search();
              },
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        _listKategoriBuku.isEmpty && checkDataEmpty == false
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: _listKategoriBuku.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          BannerListTile(
                            showBanner: false,
                            // bannerText: 'test',
                            // bannerColor: Colors.red,
                            backgroundColor: Colors.white,
                            title: Text(
                              _listKategoriBuku[index]['nama_kategori'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailKategoriBuku(
                                    params: _listKategoriBuku[index],
                                  ),
                                ),
                              );
                              refresh();
                            },
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    }),
              ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_listKategoriBuku.isEmpty && checkDataEmpty == true
                      ? "Tidak Ada Data"
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
                            getKategoriBuku();
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
                            getKategoriBuku();
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
      ]),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateKategoriBuku(),
              ),
            );
            refresh();
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
