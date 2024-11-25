import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/Addcontribution.dart';
import 'package:meal_management_system/pages/Addmeal.dart';
import 'package:meal_management_system/pages/addbazar.dart';
import 'package:meal_management_system/pages/addmember.dart';
import 'package:meal_management_system/pages/orderlist.dart';

import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';
const Color lightBeige = Color(0xFFF9E4C8);

class HomePage extends StatefulWidget {
  final String userEmail;
  final String userName; // Add a userName field

  const HomePage({super.key, required this.userEmail, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMenu = false;
  DbHelper dbHelper = DbHelper();
  Database? database;
  List<Map<String, Object?>>? data;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    database = await dbHelper.database;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orangeAccent,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  showMenu = !showMenu;
                });
              },
              icon: showMenu
                  ? Icon(
                Icons.arrow_back_outlined,
                size: size.width * 0.1,
              )
                  : Icon(Icons.list, size: size.width * 0.1),
              style: ButtonStyle(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_circle,
                        size: size.width * 0.1,
                      )),
                ),
              )
            ]),
        body: showMenu
            ? AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          height: size.height,
          width: size.width * 0.55,
          color: Color.fromRGBO(255, 165, 0, 0.3),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "WELCOME",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.05),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,top: 10),
                  child: Text(
                    widget.userName.toUpperCase(),
                    style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        )
            : Container(
          color: lightBeige,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width * 0.88,
                  height: size.height * 0.4,
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (value) => Addmember()));
                                },
                                child: Image.asset(
                                  "assets/images/admember.png",
                                  width: size.width * 0.235,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (value) => Addmeal()));
                                },
                                child: Image.asset(
                                  "assets/images/admeal.png",
                                  width: size.width * 0.235,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (value) => AddContribution(userEmail: widget.userEmail),  // Passing userEmail correctly
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/addmoney.png",
                                  width: size.width * 0.22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (value) => AddBazaarPage()
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/images/addbazar.png",
                                width: size.width * 0.25,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (value) => OrdersListScreen()  // Passing userEmail correctly
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/images/view order.png",
                                width: size.width * 0.235,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
