import 'package:flutter/material.dart';
import 'package:juice_buddy_user/screens/welcome_screen.dart';
import 'package:juice_buddy_user/screens/login_screen.dart';
import 'package:juice_buddy_user/screens/registration_screen.dart';
import 'package:juice_buddy_user/screens/user_home.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/order_main.dart';
import 'screens/error.dart';
import 'screens/mixed_fruit.dart';
import 'screens/order_final.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) {
          return WelcomeScreen();
        },
        LoginScreen.id: (context) {
          return LoginScreen();
        },
        RegistrationScreen.id: (context) {
          return RegistrationScreen();
        },
        UserHome.id: (context) {
          return UserHome();
        },
        OrderMain.id: (context) {
          return OrderMain();
        },
        Error.id: (context) {
          return Error();
        },
        MixedFruit.id: (context) {
          return MixedFruit();
        },
        OrderFinal.id: (context) {
          return OrderFinal();
        },
      },
    );
  }
}
