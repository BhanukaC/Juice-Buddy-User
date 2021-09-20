import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:juice_buddy_user/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:juice_buddy_user/screens/order_final.dart';
import 'package:juice_buddy_user/screens/error.dart';

class MixedFruit extends StatefulWidget {
  static final id = "mixedFruit";
  @override
  _MixedFruitState createState() => _MixedFruitState();
}

class _MixedFruitState extends State<MixedFruit> {
  bool orangeCondition = true, appleCondition = true, limeCondition = true;
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  User loggedUser;
  String name;
  bool orange = false, apple = false, lime = false;
  Map dataSnapshot;
  //bool ice = false;

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
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Juice Buddy",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Choose Ingredients for Your Mix Fruit Juice",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: CircularCheckBox(
                          value: this.apple,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => this.setState(() {
                                this.apple = !this.apple;
                              })),
                    ),
                    title: Text(
                      "Apple",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(3),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onTap: () => this.setState(() {
                      this.apple = !this.apple;
                    }),
                  ),
                ),
                Center(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: CircularCheckBox(
                          value: this.orange,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => this.setState(() {
                                this.orange = !this.orange;
                                // print(ice);
                              })),
                    ),
                    title: Text(
                      "Orange",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(3),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onTap: () => this.setState(() {
                      this.orange = !this.orange;
                      //print(ice);
                    }),
                  ),
                ),
                Center(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: CircularCheckBox(
                          value: this.lime,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          disabledColor: Colors.grey,
                          onChanged: (val) => this.setState(() {
                                this.lime = !this.lime;
                              })),
                    ),
                    title: Text(
                      "Lime",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(3),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onTap: () => this.setState(() {
                      this.lime = !this.lime;
                    }),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    name: 'Order',
                    onTap: () async {
                      if (apple || orange || lime) {
                        print("hi");
                        await databaseReference
                            .once()
                            .then((DataSnapshot snapshot) {
                          dataSnapshot = snapshot.value;
                          //print('Data : ${dataSnapshot}');
                        });
                        var customerBalance =
                            dataSnapshot["Customers"][name]["balance"];
                        var ownerBalance = dataSnapshot["Owner"]["Balance"];
                        var count = dataSnapshot["Orders"]["Count"];
                        count++;
                        var ice = dataSnapshot["MixFruit"][name]["Ice"];
                        var li = List();
                        print(name);
                        print(count);

                        if (apple) {
                          var temp = dataSnapshot["Fruits"]["Apple"];
                          if (temp["Allow"] &&
                              temp["Fill"] &&
                              temp["PH"] > temp["Lowph"] &&
                              temp["PH"] < temp["Highph"]) {
                            li.add("Apple");
                          } else {
                            appleCondition = false;
                          }
                        }

                        if (orange) {
                          var temp = dataSnapshot["Fruits"]["Orange"];
                          if (temp["Allow"] &&
                              temp["Fill"] &&
                              temp["PH"] > temp["Lowph"] &&
                              temp["PH"] < temp["Highph"]) {
                            li.add("Orange");
                          } else {
                            orangeCondition = false;
                          }
                        }
                        if (lime) {
                          var temp = dataSnapshot["Fruits"]["Lime"];
                          if (temp["Allow"] &&
                              temp["Fill"] &&
                              temp["PH"] > temp["Lowph"] &&
                              temp["PH"] < temp["Highph"]) {
                            li.add("Lime");
                          } else {
                            limeCondition = false;
                          }
                        }
                        double appleLevel = 0, orangeLevel = 0, limeLevel = 0;
                        print(li.length);
                        var partVolume =
                            ice ? 400 / li.length : 500 / li.length;

                        for (String s in li) {
                          if (s.compareTo("Apple") == 0) {
                            appleLevel = partVolume;
                          } else if (s.compareTo("Orange") == 0) {
                            orangeLevel = partVolume;
                          } else if (s.compareTo("Lime") == 0) {
                            limeLevel = partVolume;
                          }
                        }
                        if (appleCondition &&
                            orangeCondition &&
                            limeCondition) {
                          await databaseReference
                              .child("Orders")
                              .child(count.toString())
                              .set({
                            "Apple": appleLevel,
                            "Orange": orangeLevel,
                            "Lime": limeLevel,
                            "Ice": ice
                          }).asStream(); //put order
                          await databaseReference
                              .child("Owner")
                              .child("Transactions")
                              .push()
                              .set({name: 80}).asStream();
                          await databaseReference
                              .child('Owner')
                              .update({"Balance": ownerBalance + 80});
                          await databaseReference
                              .child('Customers')
                              .child(name)
                              .update({"balance": customerBalance - 80});
                          await databaseReference
                              .child('Orders')
                              .update({"Count": count});

                          Navigator.pushNamed(context, OrderFinal.id);
                        } else {
                          Navigator.pushNamed(context, Error.id);
                        }
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
