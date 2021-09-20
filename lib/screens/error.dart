import 'package:flutter/material.dart';
import 'package:juice_buddy_user/screens/user_home.dart';

class Error extends StatefulWidget {
  static final id = "error";
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AnimationController animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    animationController.forward();
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        Navigator.pushNamed(context, UserHome.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Juice Buddy",
        ),
      ),
      body: Container(
        child: Center(
            child: Expanded(
          child: Text(
            "Please wait 10 minutes until Refill ",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
