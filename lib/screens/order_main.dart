import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:juice_buddy_user/components/rounded_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juice_buddy_user/screens/error.dart';
import 'package:juice_buddy_user/screens/mixed_fruit.dart';
import 'package:juice_buddy_user/screens/order_final.dart';

class OrderMain extends StatefulWidget {
  static final id = "order_main";
  @override
  _OrderMainState createState() => _OrderMainState();
}

class _OrderMainState extends State<OrderMain> {
  final _auth = FirebaseAuth.instance;
  bool ice = false;
  final databaseReference = FirebaseDatabase.instance.reference();
  User loggedUser;
  String name;
  String type;
  Map dataSnapshot;
  double apple, lime, orange;

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Center(
              child: Text(
                "Choose Juice you Want",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomRadioButton(
              padding: 8,
              horizontal: true,
              autoWidth: true,
              enableShape: true,
              absoluteZeroSpacing: false,
              enableButtonWrap: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [
                'Apple',
                'Orange',
                'Lime',
                "Mixed Fruit",
              ],
              buttonValues: [
                'Apple',
                'Orange',
                'Lime',
                "Mixed Fruit",
              ],
              buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                type = value;
              },
              selectedColor: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: CircularCheckBox(
                  value: this.ice,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  inactiveColor: Colors.redAccent,
                  disabledColor: Colors.grey,
                  onChanged: (val) => this.setState(() {
                        this.ice = !this.ice;
                        print(ice);
                      })),
            ),
            title: Text(
              "I want Ice",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            contentPadding: EdgeInsets.all(3),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            onTap: () => this.setState(() {
              this.ice = !this.ice;
              print(ice);
            }),
          ),
          RoundedButton(
            color: Colors.red,
            name: "Order A Juice",
            onTap: () async {
              await databaseReference.once().then((DataSnapshot snapshot) {
                dataSnapshot = snapshot.value;
                //print('Data : ${dataSnapshot}');
              });
              var customerBalance = dataSnapshot["Customers"][name]["balance"];
              var ownerBalance = dataSnapshot["Owner"]["Balance"];
              var count = dataSnapshot["Orders"]["Count"];
              lime = 0;
              orange = 0;
              apple = 0;
              count++;
              if (type.compareTo("Apple") == 0) {
                var temp = dataSnapshot["Fruits"][type];
                if (temp["Allow"] &&
                    temp["Fill"] &&
                    temp["PH"] > temp["Lowph"] &&
                    temp["PH"] < temp["Highph"]) {
                  print(name);
                  apple = ice ? 400 : 500;
                  await databaseReference
                      .child("Orders")
                      .child(count.toString())
                      .set({
                    "Apple": apple,
                    "Orange": orange,
                    "Lime": lime,
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
              } else if (type.compareTo("Orange") == 0) {
                var temp = dataSnapshot["Fruits"][type];
                if (temp["Allow"] &&
                    temp["Fill"] &&
                    temp["PH"] > temp["Lowph"] &&
                    temp["PH"] < temp["Highph"]) {
                  print(name);
                  orange = ice ? 400 : 500;
                  await databaseReference
                      .child("Orders")
                      .child(count.toString())
                      .set({
                    "Apple": apple,
                    "Orange": orange,
                    "Lime": lime,
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
              } else if (type.compareTo("Lime") == 0) {
                var temp = dataSnapshot["Fruits"][type];
                if (temp["Allow"] &&
                    temp["Fill"] &&
                    temp["PH"] > temp["Lowph"] &&
                    temp["PH"] < temp["Highph"]) {
                  print(name);
                  lime = ice ? 400 : 500;
                  await databaseReference
                      .child("Orders")
                      .child(count.toString())
                      .set({
                    "Apple": apple,
                    "Orange": orange,
                    "Lime": lime,
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
              } else if (type.compareTo("Mixed Fruit") == 0) {
                await databaseReference
                    .child("MixFruit")
                    .child(name)
                    .set({"Ice": ice}).asStream();
                Navigator.pushNamed(context, MixedFruit.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
