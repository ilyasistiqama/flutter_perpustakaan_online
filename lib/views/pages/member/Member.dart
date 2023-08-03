// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:perpus_example_case/controllers/MemberController.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  late MemberController _memberController;
  List _listMember = [];
  int page = 1;
  bool _nextPage = false;

  setData(data) {
    if (data is Map) {
      if (data['key'] == 666) {
        setState(() {
          _listMember = data['payload']['listMember'];
          if (_listMember.length >= 10) {
            _nextPage = true;
          } else {
            _nextPage = false;
          }
        });
      }
    }
  }

  @override
  void initState() {
    _memberController = MemberController();
    _memberController.getMember(context, page, setData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member')),
      body: Column(
        children: [
          _listMember.isEmpty
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _listMember.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                            "${_listMember[index]['name']} - (${_listMember[index]['roles'][0]['name'].toUpperCase()})",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(_listMember[index]['email']),
                        leading: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(20),
                            child: Image.network(
                              'https://xsgames.co/randomusers/avatar.php?g=pixel',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                    Text(_listMember.isEmpty
                        ? "Tidak ada Data"
                        : "Page : $page"),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    (page != 1)
                        ? ElevatedButton(
                            onPressed: () async {
                              page--;
                              await _memberController.getMember(
                                  context, page, setData);
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
                            onPressed: () async {
                              page++;
                              await _memberController.getMember(
                                  context, page, setData);
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
}
