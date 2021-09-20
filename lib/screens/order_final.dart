import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:juice_buddy_user/components/rounded_button.dart';
import 'package:juice_buddy_user/screens/user_home.dart';

class OrderFinal extends StatefulWidget {
  static final id = "orderFinal";
  @override
  _OrderFinalState createState() => _OrderFinalState();
}

class _OrderFinalState extends State<OrderFinal>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  User loggedUser;
  String name;
  double balance;
  AnimationController animationController;

  void getCurrentUser() async {
    try {
      var user = await _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        await loggedUser.email;
        setState(() {
          name = loggedUser.email.split("@")[0];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      lowerBound: 0,
      upperBound: 100,
    );
    animationController.forward();
    animationController.addListener(() {
      print(animationController.status);
      setState(() {});
    });
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        Navigator.pushNamed(context, UserHome.id);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(loggedUser.email.split("@")[0]);

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popUntil(
                    context, (r) => r.settings.name == UserHome.id);
              }),
        ],
        title: Center(child: Text("Juice Buddy")),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Please Put Cup on Marked place and Wait",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Your Account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                                child: FirebaseAnimatedList(
                                    query: databaseReference
                                        .child("Customers")
                                        .child(name),
                                    itemBuilder: (BuildContext context,
                                        DataSnapshot snapshot,
                                        Animation<double> animation,
                                        int index) {
                                      balance = snapshot.value.toDouble();
                                      return ListTile(
                                        title: Center(
                                          child: Text(
                                              "Balance is ${snapshot.value}",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                              )),
                                        ),
                                      );
                                    })),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Your Charge is Rs.80",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber[100],
                    ),
                    child: Center(
                        child: Text(
                      "${animationController.value.toInt()}%",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
