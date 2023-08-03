// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:perpus_example_case/utils/CustomDialog.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ForSetData { forDashboard }

class DashboardController {
  Future getDashboard(context,setData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        '${Globals.urlApi}book/dashboard',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        Map payload = {
          'key': ForSetData.forDashboard,
          'payload': {
            'totalBuku':
                response.data['data']['dashboard']['totalBuku'].toString(),
            'totalStok':
                response.data['data']['dashboard']['totalStok'].toString(),
            'totalMember':
                response.data['data']['dashboard']['totalMember'].toString(),
            'totalPegawai':
                response.data['data']['dashboard']['totalPegawai'].toString(),
            'totalPeminjaman':
                response.data['data']['dashboard']['totalDipinjam'].toString(),
            'totalDikembalikan': response.data['data']['dashboard']
                    ['totalDikembalikan']
                .toString(),
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
