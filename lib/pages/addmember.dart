import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/showmembers.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';

class Addmember extends StatefulWidget {
  const Addmember({super.key});

  @override
  State<Addmember> createState() => _AddmemberState();
}

class _AddmemberState extends State<Addmember> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController numberController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: size.width,
                child: Row(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 240,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (value)=>Showmembers()));
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.black,
                            textDirection: TextDirection.ltr,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add new user",
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "enter your name";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.contains("@")) {
                            return null;
                          }
                          return "enter your email";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                            hintText: "Mobile no",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length == 11) {
                            return null;
                          }
                          return "enter your mobile number";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: TextFormField(
                        controller: passController,
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length >= 8) {
                            return null;
                          }
                          return "password must contain atleast 8 character";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: conPassController,
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              conPassController.text == passController.text) {
                            return null;
                          }
                          return "password must match";
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {

                                await dbHelper.insertUser(
                                  nameController.text,
                                  emailController.text,
                                  numberController.text,
                                  passController.text,
                                  conPassController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("User Added Successfully")));
                                nameController.clear();
                                emailController.clear();
                                numberController.clear();
                                passController.clear();
                                conPassController.clear();
                              } catch (e) {
                                print("Error inserting data: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error: Could not register user. Make sure the database is correctly set up.")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 45),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color: Colors.black),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
