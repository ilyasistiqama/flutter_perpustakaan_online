// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:perpus_example_case/utils/CustomDialog.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberController {
  Future getMember(context, page, setData) async {
    List listMember = [];

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      var queryParams = <String, dynamic>{"page": page};

      var response = await dio.get(
        "${Globals.urlApi}user/all",
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${prefs.getString('token').toString()}",
          },
        ),
      );

      if (response.data['status'] == 200) {
        listMember = response.data['data']['users']['data'];
        Map payload = {
          "key": 666,
          "payload": {
            'listMember': listMember,
          }
        };
        setData(payload);

      } else {
        CustomDialog.getDialogOnly(
            title: 'Perhatian',
            message: response.data['message'].toString(),
            context: context);
      }
    } on DioError catch (e) {
      CustomDialog.getDialogOnly(
          title: 'Perhatian', message: e.message.toString(), context: context);
    }
  }
}
