import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:juice_buddy_user/components/rounded_button.dart';
import 'package:juice_buddy_user/constants.dart';
import 'order_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserHome extends StatefulWidget {
  static const String id = "user_home";
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  User loggedUser;
  String name;
  double balance;

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
                Navigator.pop(context);
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 150,
                    ),
                  ),
                ],
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
                              height: 10,
                            ),
                            Text(
                              "Hi $name",
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
                child: RoundedButton(
                  color: Colors.red,
                  name: "Ask To Top Up",
                  onTap: () {
                    databaseReference
                        .child("Owner")
                        .child("Ask")
                        .child(name)
                        .set({
                      "amount": 1000,
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RoundedButton(
                  color: Colors.red,
                  name: "Order A Juice",
                  onTap: () {
                    if (balance >= 80) {
                      Navigator.pushNamed(context, OrderMain.id);
                    } else {
                      showAlertDialog(context);
                    }
                    //
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Insufficient Balance"),
    content: Text("Please Recharge your Account"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
