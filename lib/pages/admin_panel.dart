import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/Register_page.dart';
import 'package:meal_management_system/pages/home_page.dart';
import 'package:meal_management_system/services/auth_service.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';

class Admin_panel extends StatefulWidget {
  const Admin_panel({super.key});

  @override
  State<Admin_panel> createState() => _Admin_panelState();
}

class _Admin_panelState extends State<Admin_panel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  DbHelper dbHelper = DbHelper();
  Database? database;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    database = await dbHelper.database;
  }

  bool isObsecure = true;
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
          )),
          child: Column(children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ClipRRect(
                child: Image.asset(
                  "assets/images/Logo1.png",
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                ),
              ),
            ),
            Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w900,
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Enter your email",
                            ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "enter your email";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: passController,
                        obscureText: isObsecure,
                        decoration: InputDecoration(
                            hintText: "Enter your password.",

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObsecure = !isObsecure;
                                });
                              },
                              icon: Icon(
                                isObsecure
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.visibility_off_rounded,
                              ),
                            )),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "enter your pass";
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final db = await dbHelper.database;
                              var res = await dbHelper.adminLoginCheck(
                                  emailController.text, passController.text);

                              if (res != 0) { // If login is successful
                                String userEmail = emailController.text;
                                String? userName = await dbHelper.getAdminNameByEmail(userEmail);

                                if (userName != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        userEmail: userEmail,
                                        userName: userName,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("User name not found.")),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid credentials.")),
                                );
                              }
                            } catch (e) {
                              print("Error: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("An error occurred. Please try again.")),
                              );
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.orangeAccent),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 45),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            "Dont have an account?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (value) => RegisterPage()));
                            },
                            child: Text(
                              "  Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ])),
    ));
  }
}
