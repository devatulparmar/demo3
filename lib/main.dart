import 'package:myDemo/screens/choose_location.dart';
import 'package:myDemo/screens/home.dart';
import 'package:myDemo/screens/last_screen.dart';
import 'package:myDemo/screens/list_screen.dart';
import 'package:myDemo/screens/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:myDemo/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.getInstance();
  // timer start
  runApp(GestureDetector(
    onTap: (){
      //
    },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/list',
      routes: {
        '/': (context) => const Home(),
        '/location': (context) => const ChooseLocation(),
        '/next': (context) => const NextScreen(),
        '/list': (context) => const ListScreen(),
        '/last': (context) => const LastScreen(email: '', password: '', arg: {},),
      },
    ),
  ),
  );
}
