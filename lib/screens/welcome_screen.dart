import 'package:juice_buddy_user/screens/login_screen.dart';
import 'package:juice_buddy_user/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:juice_buddy_user/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1), upperBound: 1.0);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      // print(animation.value);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: controller.value * 100,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500),
                  totalRepeatCount: 4,
                  repeatForever: true,
                  text: ['JUICE BUDDY'],
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              name: 'Log In',
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
                //Go to login screen.
              },
            ),
            RoundedButton(
              color: Colors.blueAccent,
              name: 'Register',
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
