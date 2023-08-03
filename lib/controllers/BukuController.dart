// ignore_for_file: file_names, non_constant_identifier_names


import 'package:dio/dio.dart';
import 'package:perpus_example_case/utils/CustomDialog.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum ForSetData {
  forListBukuGetCategory,
  forListBukuGetBuku,
  forListBukuGetBukuByFiltered,
  forCreatedBuku,
  forUpdatedBuku,
}

class BukuController {
  Future getCategory(setData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();

    var dio = Dio();
    var response = await dio.get(
      "${Globals.urlApi}category/all/all",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    if (response.data['status'] == 200) {
      Map payload = {
        'key': ForSetData.forListBukuGetCategory,
        'payload': response.data['data']['categories']
      };
      setData(payload);
    }
  }

  Future getBuku(context, page, ListBuku, endPage, setData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
        "per_page": 9,
      };
      var response = await dio.get(
        "${Globals.urlApi}book/all",
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        List temporary = response.data['data']['books']['data'];
        // List <BookModel> listHehe = <BookModel> [];
        if (temporary.isNotEmpty) {
          // ignore: avoid_function_literals_in_foreach_calls
          temporary.forEach((element) => ListBuku.add(element));
        }
        endPage = false;

        if (response.data['data']['books']['next_page_url'].toString() ==
            'null') {
          endPage = true;
        }

        Map payload = {
          "key": ForSetData.forListBukuGetBuku,
          "payload": {
            'progress': false,
            'firstLoad': false,
            'page': page++,
            'listBuku': ListBuku,
            'endPage': endPage,
            // 'dataObj': listHehe,
          }
        };
        setData(payload);
      } else {
      }
    } on DioError catch (e) {
      CustomDialog.getDialogOnly(
          title: 'Perhatian', message: e.message.toString(), context: context);
    }
  }

  Future getBukuByFiltered(
      context, filterkategori, page, endPage, searchAttribute, setData) async {
    try {
      List ListBuku = [];
      page = 1;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
        "per_page": 9,
        "search": searchAttribute.text,
      };
      if (filterkategori != null) {
        queryParams = <String, dynamic>{
          "page": page,
          "per_page": 9,
          "search": searchAttribute.text,
          "filter": filterkategori
        };
      }
      var response = await dio.get(
        "${Globals.urlApi}book/all",
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        ListBuku = [];
        List temporary = response.data['data']['books']['data'];
        if (temporary.isNotEmpty) {
          for (var element in temporary) {
            ListBuku.add(element);
          }
        }
        Map payload = {
          "key": ForSetData.forListBukuGetBukuByFiltered,
          "payload": {'progress': false, 'listBuku': ListBuku, 'page': page}
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

  Future exportPdfBuku(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        "${Globals.urlApi}book/export/pdf",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data['status'] == 200) {
        // ignore: deprecated_member_use
        await launch(Globals.url + response.data['path']);
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
    // return [];
  }

  Future exportExcelBuku(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token;
      token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        "${Globals.urlApi}book/export/excel",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data['status'] == 200) {
        // ignore: deprecated_member_use
        await launch(Globals.url + response.data['path']);
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

  Future<List> getCategoryInForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();

    var dio = Dio();
    var response = await dio.get(
      "${Globals.urlApi}category/all/all",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response.data['data']['categories'];
  }

  insertBuku(context, formData, setData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();
    Dio dio = Dio();

    try {
      var response = await dio.post(
        "${Globals.urlApi}book/create",
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      Map payload = {'key': ForSetData.forCreatedBuku, 'payload': false};
      setData(payload);

      if (response.data['status'] == 201) {
        CustomDialog.getDialogCameBackTwice(
            title: 'Sukses',
            message: response.data['message'].toString(),
            context: context);
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

  updateBuku(context, formData, id, setData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();
    Dio dio = Dio();

    try {
      var response = await dio.post(
        "${Globals.urlApi}book/$id/update",
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          headers: {
            // "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      Map payload = {'key': ForSetData.forUpdatedBuku, 'payload': false};
      setData(payload);

      if (response.data['status'] == 200) {
        CustomDialog.getDialogCameBackThreeTimes(
            title: 'Perhatian',
            message: response.data['message'].toString(),
            context: context);
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

  Future deleteBuku(id, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token').toString();

    var dio = Dio();
    try {
      var response = await dio.delete(
        "${Globals.urlApi}book/$id/delete",
        data: null,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 200) {
        CustomDialog.getDialogCameBackTwice(
            title: 'Sukses',
            message: response.data['message'].toString(),
            context: context);
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
