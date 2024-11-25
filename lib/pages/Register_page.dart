import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/admin_panel.dart';
import 'package:meal_management_system/pages/user_page.dart';
import 'package:meal_management_system/services/auth_service.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/dbhelpe.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
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
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Create Account",
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
                              await dbHelper.insertAdmin(
                                nameController.text,
                                emailController.text,
                                passController.text,
                                conPassController.text,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Admin_panel()),
                              );
                            } catch (e) {
                              print("Error inserting data: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: Could not register user. Make sure the database is correctly set up.")),
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
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: size.width * 0.05, color: Colors.black),
                          ),
                        ),
                      )

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (value) => Admin_panel()));
                            },
                            child: Text(
                              "  Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),
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
