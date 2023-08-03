// ignore_for_file: file_names
import 'package:banner_listtile/banner_listtile.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:perpus_example_case/controllers/BukuController.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/pages/buku/form/CreateBuku.dart';
import 'package:perpus_example_case/views/pages/buku/form/DetailBuku.dart';
import 'package:perpus_example_case/views/pages/buku/form/ExportBuku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBuku extends StatefulWidget {
  const ListBuku({super.key});

  @override
  State<ListBuku> createState() => _ListBukuState();
}

class _ListBukuState extends State<ListBuku> {
  late BukuController _bukuController;
  bool firstLoad = true;
  late String _role;
  bool _visible = false;
  List _listKategoriBuku = [];
  // ignore: non_constant_identifier_names
  List _ListBuku = [];
  int page = 1;
  bool progress = false;
  bool endPage = false;
  final TextEditingController _searchAttribute = TextEditingController();

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('roles').toString();
      if (_role == 'admin') {
        _visible = true;
      }
    });
  }

  setData(data) {
    if (data is Map) {
      if (data['key'] == ForSetData.forListBukuGetBuku) {
        setState(() {
          progress = data['payload']['progress'];
          firstLoad = data['payload']['firstLoad'];
          page = data['payload']['page'];
          _ListBuku = data['payload']['listBuku'];
          endPage = data['payload']['endPage'];
          page++;
        });
      } else if (data['key'] == ForSetData.forListBukuGetBukuByFiltered) {
        setState(() {
          progress = data['payload']['progress'];
          _ListBuku = data['payload']['listBuku'];
          page = data['payload']['page'];
        });
      } else if(data['key'] == ForSetData.forListBukuGetCategory){
        setState((){
        _listKategoriBuku = data['payload'];
        });
      }
    }
  }

  void _refresh() async {
    setState(() {
      progress = false;
      endPage = false;
      _ListBuku = [];
      page = 1;
    });
    await _bukuController.getBuku(context, page, _ListBuku, endPage, setData);
  }

  @override
  void initState() {
    getRoles();
    _bukuController = BukuController();
    _bukuController.getCategory(setData);
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Buku'),
        actions: <Widget>[
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                await _bukuController.exportPdfBuku(context);
              },
              icon: const Icon(Icons.picture_as_pdf),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExportBuku(),
                  ),
                );
                _refresh();
              },
              icon: const Icon(Icons.upload),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                await _bukuController.exportExcelBuku(context);
              },
              icon: const Icon(Icons.upload_file),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchAttribute,
                    decoration: InputDecoration(
                      // hintText: "Masukkan Judul Buku Anda",
                      labelText: "Search Judul",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchAttribute.text = '';
                          });
                          _refresh();
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
                  minimumSize: const Size(50, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  _bukuController.getBukuByFiltered(
                      context, null, page, endPage, _searchAttribute, setData);
                },
                icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
          Container(
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              itemCount: _listKategoriBuku.length,
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          _bukuController.getBukuByFiltered(
                              context,
                              _listKategoriBuku[index]['id'].toString(),
                              page,
                              endPage,
                              _searchAttribute,
                              setData);
                        },
                        child: Text(_listKategoriBuku[index]['nama_kategori']),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                );
              },
            ),
          ),
          (firstLoad)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () async {
                      if (!progress && !endPage) {
                        setState(() {
                          progress = true;
                        });
                        await _bukuController.getBuku(
                            context, page, _ListBuku, endPage, setData);
                      }
                    },
                    child: ListView.builder(
                      itemCount: _ListBuku.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(children: [
                            BannerListTile(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailBuku(
                                      _ListBuku[index],
                                    ),
                                  ),
                                );
                                _refresh();
                              },
                              showBanner: false,
                              // bannerText: '',
                              // bannerColor: const Color(0xFFE7E7E7),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(8),
                              // imageContainerShapeZigzagIndex: index,
                              imageContainer:
                                  CoverBuku(_ListBuku[index]['path']),
                              title: Text(
                                _ListBuku[index]['judul'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                _ListBuku[index]['category']['nama_kategori'],
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              trailing: const IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ),
          progress == true
              ? const Visibility(
                  visible: true,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const Visibility(
                  visible: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateBuku(),
              ),
            );
            _refresh();
          },
          child: const Icon(Icons.add),
        ),
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
