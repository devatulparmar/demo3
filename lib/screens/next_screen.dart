import 'package:myDemo/screens/last_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myDemo/utils/const.dart';
import 'package:myDemo/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future login() async {
    try {
      final response = await dio.post(
        "https://reqres.in/api/login",
          data: {
            "email": "eve.holt@reqres.in",
            "password": "cityslicka"
            // "email": emailController.text,
            // "password": passwordController.text
          },
          options: Options(
            receiveTimeout: const Duration(seconds: 3),
            sendTimeout: const Duration(seconds: 1),
          ),
      );

      // final response = await dio.get('https://dummy.restapiexample.com/api/v1/employees');

      if (response.statusCode == 200) {
        debugPrint('----> ${response.data}');
        emailController.text = '';
        passwordController.text = '';
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool(prefLoginKey, true);

        SharedPrefs.putBool(prefLoginKey, true);
        debugPrint("isLogin---> ${SharedPrefs.getBool(prefLoginKey)}");

        Navigator.of(context).pushNamed('/location');
      } else {
        debugPrint("statusCode---> ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('error at login $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(prefLoginKey) ?? false;
    if(value){
      Navigator.pushNamed(context, '/location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
        centerTitle: true,

        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Text('Email'),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text('Password'),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/next');
                  // Navigator.of(context).pushNamed('/next');
                  // Navigator.popAndPushNamed(context, '/last', arguments: {
                  //   'email': emailController.text,
                  //   'password': passwordController.text,
                  // });
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LastScreen(
                          email: emailController.text,
                          password: passwordController.text,
                          arg:{
                          'email': emailController.text,
                          'password': passwordController.text,
                        },
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Goto last Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
