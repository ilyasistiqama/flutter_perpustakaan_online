// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perpus_example_case/controllers/AuthenticationController.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late AuthenticationController _authenticationController;

  final TextEditingController _nameAttribute = TextEditingController();
  final TextEditingController _usernameAttribute = TextEditingController();
  final TextEditingController _emailAttribute = TextEditingController();
  final TextEditingController _passwordAttribute = TextEditingController();
  final TextEditingController _confirmPasswordAttribute =
      TextEditingController();
  bool isRegister = false;

  

  @override
  void initState() {
    _authenticationController = AuthenticationController();
    initialization();
    _authenticationController.cekAvailableToken(context);
    super.initState();
  }

  bool show = true;
  bool showConfirm = true;

  void showPassword(type) {
    setState(() {
      if (type == 1) {
        if (show) {
          show = false;
        } else {
          show = true;
        }
      } else if (type == 2) {
        if (showConfirm) {
          showConfirm = false;
        } else {
          showConfirm = true;
        }
      }
    });
  }

  setData(data) {
    if (data is Map) {
      if (data['key'] == ForSetData.forRegister) {
        setState(() {
          isRegister = data['payload'];
          _nameAttribute.text = '';
          _usernameAttribute.text = '';
          _emailAttribute.text = '';
          _passwordAttribute.text = '';
          _confirmPasswordAttribute.text = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Content(),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Content() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Start Icon
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                    //End Icon

                    const SizedBox(height: 10),

                    // Start header
                    isRegister == false
                        ? const Text(
                            "Selamat Datang. Silahkan Login",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            "Selamat Datang. Silahkan Daftar",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                    //End Header

                    const SizedBox(height: 30),

                    if (isRegister == true) InputField("Name", _nameAttribute),

                    if (isRegister == true) const SizedBox(height: 20),

                    InputField("Username", _usernameAttribute),

                    if (isRegister == true) const SizedBox(height: 20),

                    if (isRegister == true)
                      InputField("Email", _emailAttribute),

                    const SizedBox(height: 20),

                    InputField("Password", _passwordAttribute,
                        isPassword: true, type: 1),

                    if (isRegister == true) const SizedBox(height: 20),

                    if (isRegister == true)
                      InputField("Confirm Password", _confirmPasswordAttribute,
                          isPassword: true, type: 2),

                    const SizedBox(height: 50),

                    //Start Button Login
                    ElevatedButton(
                      onPressed: () async {
                        isRegister == false
                            ? await _authenticationController.loginUser(
                                _usernameAttribute, _passwordAttribute, context)
                            : await _authenticationController.registerUser(
                                _nameAttribute,
                                _usernameAttribute,
                                _emailAttribute,
                                _passwordAttribute,
                                _confirmPasswordAttribute,
                                context,
                                setData);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor:
                            const Color.fromARGB(255, 228, 226, 226),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isRegister == false
                          ? const SizedBox(
                              width: double.infinity,
                              child: Text("Sign In",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            )
                          : const SizedBox(
                              width: double.infinity,
                              child: Text("Register",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                    ),
                    //End Button Login
                    const SizedBox(height: 10),

                    //Redirect to Register
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isRegister == true
                              ? isRegister = false
                              : isRegister = true;

                          _nameAttribute.text = '';
                          _usernameAttribute.text = '';
                          _emailAttribute.text = '';
                          _passwordAttribute.text = '';
                          _confirmPasswordAttribute.text = '';
                        });
                      },
                      child: isRegister == false
                          ? const Text(
                              'Register in Here',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            )
                          : const Text(
                              'Login in Here',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InputField(String hintText, TextEditingController paramController,
      {isPassword = false, type}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: paramController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: (isPassword == true)
            ? IconButton(
                onPressed: () {
                  showPassword(type);
                },
                icon: (type == 1 ? show : showConfirm)
                    ? const Icon(Icons.visibility_off, color: Colors.white)
                    : const Icon(Icons.visibility, color: Colors.white),
              )
            : null,
      ),
      obscureText: (type == 1
          ? (show ? isPassword : false)
          : (showConfirm ? isPassword : false)),
    );
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }
}
