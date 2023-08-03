// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_example_case/utils/CustomDialog.dart';
import 'package:perpus_example_case/utils/Globals.dart';
import 'package:perpus_example_case/views/navbar/Navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ForSetData { forRegister }

class AuthenticationController {
  loginUser(usernameAttribute, passwordAttribute, context) async {
    var dio = Dio();

    if (usernameAttribute.text == '' || passwordAttribute.text == '') {
      CustomDialog.getDialogOnly(
          title: 'Perhatian',
          message: 'Username dan password wajib diisi',
          context: context);
    } else {
      try {
        var formData = FormData.fromMap({
          'username': usernameAttribute.text,
          'password': passwordAttribute.text
        });
        var response = await dio.post("${Globals.urlApi}login", data: formData);
        if (response.data['status'] == 200) {
          final prefs = await SharedPreferences.getInstance();

          var idUser = response.data['data']['user']['id'];
          var token = response.data['data']['token'];
          var roles = response.data['data']['user']['roles'][0]['name'];

          await prefs.setString('idUser', idUser.toString());
          await prefs.setString('token', token.toString());
          await prefs.setString('roles', roles.toString());

          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Navbar()),
          );
        } else {
          CustomDialog.getDialogOnly(
              title: 'Perhatian',
              message: response.data['message'].toString(),
              context: context);
        }
      } on DioError catch (e) {
        CustomDialog.getDialogOnly(
            title: 'Perhatian',
            message: e.message.toString(),
            context: context);
      }
    }
  }

  registerUser(name, username, email, password, confirmPassword, context,
      setData) async {
    var dio = Dio();
    bool? isRegister = true;
    try {
      var formData = FormData.fromMap({
        'name': name.text,
        'username': username.text,
        'email': email.text,
        'password': password.text,
        'confirm_password': confirmPassword.text
      });

      var response =
          await dio.post("${Globals.urlApi}register", data: formData);
      if (response.data['status'] == 200) {
        isRegister = false;

        Map payload = {"key": ForSetData.forRegister, "payload": isRegister};
        setData(payload);
        CustomDialog.getDialogOnly(
            title: 'Sukses',
            message: response.data['message'],
            context: context);
      } else {
        CustomDialog.getDialogOnly(
            title: 'Perhatian',
            message: response.data['message']['message'],
            context: context);
      }
    } on DioError catch (e) {
      CustomDialog.getDialogOnly(
          title: 'Perhatian', message: e.message.toString(), context: context);
    }
  }

  cekAvailableToken(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    if (token.length != 4) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    }
  }
}
